--
-- LOGS AND TRIGGERS
--
-- Create log table if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'user_log' AND schema_id = SCHEMA_ID('general'))
BEGIN
    CREATE TABLE general.user_log (
        log_id INT IDENTITY(1,1) PRIMARY KEY,
        operation NVARCHAR(10) NOT NULL,
        user_id NVARCHAR(100),
        name NVARCHAR(100),
        last_name NVARCHAR(100),
        email NVARCHAR(100),
        country_user NVARCHAR(100),
        phone NVARCHAR(40),
        operation_time DATETIME DEFAULT GETDATE()
    );
END;
GO

-- Create trigger for logging changes on the [user] table
CREATE TRIGGER general.tr_user_log
ON general.[user]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log INSERT operations
    INSERT INTO general.user_log (operation, user_id, name, last_name, email, country_user, phone, operation_time)
    SELECT 'INSERT', user_id, name, last_name, email, country_user, phone, GETDATE()
    FROM inserted;

    -- Log UPDATE operations
    INSERT INTO general.user_log (operation, user_id, name, last_name, email, country_user, phone, operation_time)
    SELECT 'UPDATE', i.user_id, i.name, i.last_name, i.email, i.country_user, i.phone, GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.user_id = d.user_id;

    -- Log DELETE operations
    INSERT INTO general.user_log (operation, user_id, name, last_name, email, country_user, phone, operation_time)
    SELECT 'DELETE', user_id, name, last_name, email, country_user, phone, GETDATE()
    FROM deleted;
END;
GO


--
-- IN MEMORY TABLES
--


-- Create a copy of listen
SELECT * INTO general.listen_backup FROM general.listen;

-- Delete constraints
BEGIN
    ALTER TABLE general.listen DROP CONSTRAINT fk_user_id;
    ALTER TABLE general.listen DROP CONSTRAINT fk_track_id;
END;

-- Drop table
DROP TABLE IF EXISTS general.listen;

-- Create filegroup and memory data archive
ALTER DATABASE music
ADD FILEGROUP memory_filegroup CONTAINS MEMORY_OPTIMIZED_DATA;

ALTER DATABASE music
ADD FILE (name = 'memory_data', filename = 'C:\Users\'/*replace with the desired path*/) 
TO FILEGROUP memory_filegroup;

-- Create the in-memory table
CREATE TABLE general.listen
(
    Listen_ID INT IDENTITY(1,1) NOT NULL, -- Auto-increment Listen_ID
    user_id NVARCHAR(100) NOT NULL,
    Track_ID INT NOT NULL,
    Date_time DATETIME,
    Country_listen NVARCHAR(100),
    CONSTRAINT PK_Listen PRIMARY KEY NONCLUSTERED (Listen_ID)
) 
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);

-- Check filegroups
SELECT 
    name AS FilegroupName,
    type_desc AS FileType,
    is_default AS IsDefault
FROM 
    sys.filegroups;

-- Restore data from the backup table into the new table
INSERT INTO general.listen (user_id, Track_ID, Date_time, Country_listen)
SELECT user_id, Track_ID, Date_time, Country_listen
FROM general.listen_backup;


--
-- DATAFILES TEMPDB
--


USE tempdb;
GO
SELECT file_id, name, physical_name, type_desc, state_desc
FROM sys.database_files;

ALTER DATABASE tempdb
ADD FILE
(
    NAME = tempdev2,  
    FILENAME = 'C:\T13_pp2_g3_carlossobreiro_petilsoncosta_teresaraquel_vitorpeixoto\T13_pp2_g3_carlossobreiro_petilsoncosta_teresaraquel_vitorpeixoto\tempdev2.ndf',  -- change for the desired path
    SIZE = 5MB,        
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
);

SELECT file_id, name, physical_name, size/128 AS SizeMB, max_size/128 AS MaxSizeMB
FROM sys.database_files;


--
-- COMPRESSION AND PARTITION
--


-- compression
ALTER TABLE general.listen_backup
REBUILD 
WITH (DATA_COMPRESSION = ROW);
GO

ALTER TABLE general.listen_backup
REBUILD 
WITH (DATA_COMPRESSION = PAGE);
GO

SELECT 
    OBJECT_NAME(object_id) AS TableName,
    index_id AS IndexID,
    partition_number AS PartitionNumber,
    data_compression_desc AS CompressionType
FROM 
    sys.partitions
WHERE 
    OBJECT_NAME(object_id) = 'listen_backup';
GO

-- partition
CREATE PARTITION FUNCTION pf_track_id (INT)
AS RANGE LEFT FOR VALUES (1000, 2000, 3000); -- Define os intervalos

ALTER DATABASE music ADD FILEGROUP fg1;
ALTER DATABASE music ADD FILEGROUP fg2;
ALTER DATABASE music ADD FILEGROUP fg3;
ALTER DATABASE music ADD FILEGROUP fg4;


CREATE PARTITION SCHEME ps_track_id
AS PARTITION pf_track_id
TO (fg1, fg2, fg3, fg4); -- Associa as parti��es a filegroups existentes


CREATE TABLE general.listen_partitioned
(
    Listen_ID INT, --PRIMARY KEY NONCLUSTERED, 
    user_id NVARCHAR(100) NOT NULL,
    Track_ID INT NOT NULL,
    Date_time DATETIME,
    Country_listen NVARCHAR(100),
    CONSTRAINT fk_userpart_id FOREIGN KEY (user_id) REFERENCES general.[user] (user_id),
    CONSTRAINT fk_trackpart_id FOREIGN KEY (Track_ID) REFERENCES general.[Track] (Track_ID)
)
ON ps_track_id (Track_ID); -- Define que a parti��o ser� baseada em Track_ID

INSERT INTO general.listen_partitioned (Listen_ID, user_id, Track_ID, Date_time, Country_listen)
SELECT Listen_ID, user_id, Track_ID, Date_time, Country_listen
FROM general.listen;

EXEC sp_rename 'general.listen', 'general.listen_backup';


--
-- DATABASE INTEGRITY
--


DBCC CHECKDB ('music');

DBCC CHECKTABLE ('music.dbo.listen');

DBCC CHECKINDEX ('music.dbo.listen', 'idx_listen_user_id');

DBCC SHOWCONTIG ('music.dbo.listen');


--
-- @TABLE
--


DECLARE @GenreCountry TABLE (
    Country_listen NVARCHAR(100),
    music_genre NVARCHAR(50),
    genre_count INT
);

-- Insert data into the @GenreCountry
INSERT INTO @GenreCountry
SELECT 
    l.Country_listen, 
    ab.music_genre, 
    COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
WHERE CAST(l.Date_time AS TIME) BETWEEN '16:00:00.000' AND '23:59:59.999'
GROUP BY l.Country_listen, ab.music_genre;

-- Query the @GenreCountry table variable
SELECT * FROM @GenreCountry;

-- IMPORTANT NOTE: EVERYTHING NEEDS TO BE RUN AT THE SAME TIME @TABLES ONLY LAST FOR THE EXECUTION TIME
-- MEANING THAT WHEN I STOP EXECUTING A QUERY THEY DISAPPEAR


--
-- TEMPORARY TABLES
--


-- USING A SIMILAR APPROACH TO SOLVE QUESTION 20 BUT WITH TEMP TABLES
CREATE TABLE #GenreCountry (
    Country_listen NVARCHAR(100),
    music_genre NVARCHAR(50),
    genre_count INT
);

INSERT INTO #GenreCountry
SELECT 
    l.Country_listen, 
    ab.music_genre, 
    COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
WHERE CAST(l.Date_time AS TIME) BETWEEN '16:00:00.000' AND '23:59:59.999'
GROUP BY l.Country_listen, ab.music_genre;

SELECT * FROM #GenreCountry;

-- Optionally, drop the temporary table it will be dropped and the session closes
DROP TABLE #GenreCountry;
