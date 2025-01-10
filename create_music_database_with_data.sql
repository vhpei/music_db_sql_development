USE master;
GO

-- Drop the database if it exists
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'music')
BEGIN
    ALTER DATABASE music SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE music;
END
GO

-- Create the 'music' database
CREATE DATABASE music;
GO

-- Switch to 'music' database
USE music;
GO

-- Create 'general' schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'general')
BEGIN
    EXEC('CREATE SCHEMA general');
END
GO

-- =======================================
-- Create Tables
-- =======================================
-- Create 'user' table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user' AND schema_id = SCHEMA_ID('general'))
BEGIN
    CREATE TABLE general.[user] (
        user_id NVARCHAR(100) PRIMARY KEY NOT NULL,
        name NVARCHAR(100) NOT NULL,
        last_name NVARCHAR(100) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        country_user NVARCHAR(100) NOT NULL,
        phone NVARCHAR(40) NOT NULL
    );
END
GO

-- Create 'artist_band' table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'artist_band' AND schema_id = SCHEMA_ID('general'))
BEGIN
    CREATE TABLE general.artist_band (
        artist_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
        name_artist NVARCHAR(100) NOT NULL,
        country_artist NVARCHAR(100) NOT NULL,
        music_genre NVARCHAR(50) NOT NULL
    );
END
GO

-- Create 'album' table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'album' AND schema_id = SCHEMA_ID('general'))
BEGIN
    CREATE TABLE general.album (
        album_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
        album_name NVARCHAR(100) NOT NULL,
        [label] NVARCHAR(100) NOT NULL,
        artist_id INT NOT NULL
    );
END
GO

-- Create 'Track' table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Track' AND schema_id = SCHEMA_ID('general'))
BEGIN
    CREATE TABLE general.Track (
        Track_ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
        Title NVARCHAR(200) NOT NULL,
        album_ID INT NOT NULL,
        Duration INT NOT NULL -- in seconds
    );
END
GO

-- Create 'listen' table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'listen' AND schema_id = SCHEMA_ID('general'))
BEGIN
    CREATE TABLE general.listen(
        Listen_ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
        user_id NVARCHAR(100) NOT NULL,
        Track_ID INT NOT NULL,
        Date_time DATETIME,
        Country_listen NVARCHAR(100)
    );
END
GO

-- =======================================
-- Add Constraints
-- =======================================
-- Add constraints to 'user' table

BEGIN
    ALTER TABLE general.[user]
    ADD CONSTRAINT UNI_EMAIL UNIQUE (email),
	    CONSTRAINT ck_phone_format CHECK (phone LIKE '+[1-9]%' AND LEN(phone) BETWEEN 7 AND 15);
END

BEGIN
    ALTER TABLE general.listen
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES general.[user] (user_id),
		CONSTRAINT fk_track_id FOREIGN KEY (Track_ID) REFERENCES general.[Track] (Track_ID);
END

BEGIN
    ALTER TABLE general.Track
    ADD CONSTRAINT fk_album_id FOREIGN KEY (album_id) REFERENCES general.album (album_id);
END

BEGIN
    ALTER TABLE general.album
    ADD CONSTRAINT fk_artist_id FOREIGN KEY (artist_id) REFERENCES general.artist_band (artist_id);
END
GO

-- =======================================
-- Clear Existing Data
-- =======================================
DELETE FROM general.listen;
DELETE FROM general.Track;
DELETE FROM general.album;
DELETE FROM general.artist_band;
DELETE FROM general.[user];
GO

-- =======================================
-- Insert Sample Data
-- =======================================
-- Insert users
INSERT INTO general.[user] (user_id, name, last_name, email, country_user, phone)
VALUES 
    ('U001', 'Alice', 'Smith', 'alice.smith@example.com', 'USA', '+1234567890'),
    ('U002', 'Bob', 'Brown', 'bob.brown@example.com', 'Canada', '+14351234567'),
    ('U003', 'Carlos', 'Garcia', 'carlos.garcia@example.com', 'Spain', '+34911223344'),
    ('U004', 'Diana', 'White', 'diana.white@example.com', 'UK', '+441234567890'),
    ('U005', 'Eva', 'Miller', 'eva.miller@example.com', 'Germany', '+4915112345678'),
    ('U006', 'Frank', 'Adams', 'frank.adams@example.com', 'Australia', '+61412345678'),
    ('U007', 'Grace', 'Lee', 'grace.lee@example.com', 'South Korea', '+821012345678'),
    ('U008', 'Hannah', 'Kim', 'hannah.kim@example.com', 'South Korea', '+821055555555'),
    ('U009', 'Ian', 'Taylor', 'ian.taylor@example.com', 'USA', '+12345556789'),
    ('U010', 'Julia', 'Fernandez', 'julia.fernandez@example.com', 'Brazil', '+5511998765432');
GO

-- Insert artist_band
INSERT INTO general.artist_band (name_artist, country_artist, music_genre)
VALUES 
    ('The Rockers', 'USA', 'Rock'),
    ('Jazz Ensemble', 'France', 'Jazz'),
    ('Pop Stars', 'UK', 'Pop'),
    ('Classical Quartet', 'Germany', 'Classical'),
    ('Latin Grooves', 'Brazil', 'Latin'),
    ('The Blues Brothers', 'USA', 'Blues'),
    ('Hip Hop Hustlers', 'Canada', 'Hip Hop'),
    ('Electronic Dreams', 'Germany', 'Electronic'),
    ('Country Legends', 'Australia', 'Country'),
    ('Reggae Vibes', 'Jamaica', 'Reggae'),
    ('Salsa Fiesta', 'Mexico', 'Salsa'),
    ('K-Pop Kings', 'South Korea', 'Pop'),
    ('Soulful Harmonies', 'USA', 'Soul'),
    ('Indie Beats', 'UK', 'Indie'),
    ('Tango Masters', 'Argentina', 'Tango');
GO

-- Insert album
INSERT INTO general.album (album_name, [label], artist_id)
VALUES 
    ('Rocking Out', 'Epic Records', 1),
    ('Smooth Jazz Nights', 'Jazz House', 2),
    ('Pop Vibes', 'Universal Music', 3),
    ('Classic Symphony', 'Deutsche Grammophon', 4),
    ('Brazilian Beats', 'Bossa Nova Records', 5),
    ('Blues Legends', 'Blue Note', 6),
    ('Hip Hop Evolution', 'Def Jam', 7),
    ('Electronic Waves', 'Electronic Beats', 8),
    ('Country Roads', 'Outback Records', 9),
    ('Reggae Rhythm', 'Island Records', 10),
    ('Salsa Groove', 'Salsa Records', 11),
    ('K-Pop Hits', 'K-Pop World', 12),
    ('Soulful Songs', 'Soul City', 13),
    ('Indie Tunes', 'Indie Nation', 14),
    ('Tango Tango', 'Buenos Aires Classics', 15);
GO

-- Insert tracks
INSERT INTO general.Track (Title, album_id, Duration)
VALUES 
    ('Rock Anthem', 1, 210),
    ('Jazz in Paris', 2, 320),
    ('Pop Hit', 3, 180),
    ('Symphony No. 5', 4, 600),
    ('Samba de Janeiro', 5, 240),
    ('Blues Jam', 6, 250),
    ('Rap Battle', 7, 200),
    ('Techno Pulse', 8, 340),
    ('Country Ballad', 9, 300),
    ('Reggae Jam', 10, 275),
    ('Salsa Dance', 11, 230),
    ('K-Pop Fever', 12, 190),
    ('Soul Melody', 13, 220),
    ('Indie Beat', 14, 210),
    ('Tango Elegance', 15, 270),
    ('Rock Ballad', 1, 230),
    ('Jazz Fusion', 2, 300),
    ('Pop Remix', 3, 210),
    ('Symphony No. 9', 4, 650),
    ('Carnival Samba', 5, 260);
GO

-- Insert listens
INSERT INTO general.listen (user_id, Track_ID, Date_time, Country_listen)
VALUES 
    ('U001', 1, '2023-11-15 01:00:00', 'USA'),
    ('U002', 2, '2023-11-15 07:30:00', 'Canada'),
    ('U003', 3, '2023-11-15 09:00:00', 'Spain'),
    ('U004', 4, '2023-11-15 15:30:00', 'UK'),
    ('U005', 5, '2023-11-15 18:00:00', 'Germany'),
    ('U006', 6, '2023-11-15 22:30:00', 'Australia'),
    ('U007', 7, '2023-11-15 03:00:00', 'South Korea'),
    ('U008', 8, '2023-11-15 08:00:00', 'South Korea'),
    ('U009', 9, '2023-11-15 16:00:00', 'USA'),
    ('U010', 10, '2023-11-15 12:00:00', 'Brazil'),
    ('U001', 11, '2023-11-15 00:30:00', 'USA'),
    ('U002', 12, '2023-11-15 05:45:00', 'Canada'),
    ('U003', 13, '2023-11-15 19:15:00', 'Spain'),
    ('U004', 14, '2023-11-15 20:00:00', 'UK'),
    ('U005', 15, '2023-11-15 22:00:00', 'Germany');
GO
