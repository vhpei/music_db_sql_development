-- Switch to 'music' database
USE music;
GO

-- 1. Lista alfabética de utilizadores
CREATE OR ALTER PROCEDURE sp_ListarUtilizadoresOrdenados
AS
BEGIN
    SET NOCOUNT ON;

    SELECT [name]
    FROM general.[user]
    ORDER BY [name] ASC;
END;
GO


-- 2. Lista alfabética de Géneros musicais
CREATE or ALTER PROCEDURE sp_generosmusicais
AS
BEGIN
	SET NOCOUNT ON;

	SELECT music_genre
	FROM general.artist_band
	ORDER BY music_genre ASC;
END;
GO

-- 3. Lista alfabética de Etiquetas/Labels

CREATE OR ALTER PROCEDURE sp_etiquetas
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT [label]
	FROM general.album
	ORDER BY [label] ASC;
END;
GO

-- 4. Lista alfabética de bandas, por países
CREATE OR ALTER PROCEDURE sp_bandaspaises
AS
BEGIN
	SET NOCOUNT ON;

	SELECT name_artist, country_artist
	FROM general.artist_band
	ORDER BY country_artist ASC, name_artist ASC;
END;
GO


-- 5. Lista alfabética de banda, label, género, nome álbum
CREATE OR ALTER PROCEDURE sp_listaalfabeticabanda
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		ab.name_artist AS band_name, 
		al.[label], 
		ab.music_genre, 
		al.album_name
	FROM general.album al
	JOIN general.artist_band ab ON al.artist_id = ab.artist_id
	ORDER BY ab.name_artist ASC, al.[label] ASC, ab.music_genre ASC, al.album_name ASC;
END;
GO

-- 6. Lista dos 5 países com mais bandas
CREATE OR ALTER PROCEDURE sp_paisesmaisbandas
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 5 country_artist, COUNT(*) AS band_count
	FROM general.artist_band
	GROUP BY country_artist
	ORDER BY band_count DESC;
END;
GO

-- 7. Lista das 10 bandas com mais álbuns
CREATE OR ALTER PROCEDURE sp_lista10bandas
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 10 ab.name_artist, COUNT(*) AS album_count
	FROM general.album al
	JOIN general.artist_band ab ON al.artist_id = ab.artist_id
	GROUP BY ab.name_artist
	ORDER BY album_count DESC;
END;
GO

-- 8. Lista das 5 etiquetas com mais álbuns
CREATE OR ALTER PROCEDURE maisalbuns
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 5 al.[label], COUNT(*) AS album_count
	FROM general.album al
	GROUP BY al.[label]
	ORDER BY album_count DESC;
END;
GO

-- 9. Lista dos 5 géneros musicais com mais álbuns
CREATE OR ALTER PROCEDURE sp_generosmaisalbuns
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 5 ab.music_genre, COUNT(*) AS album_count
	FROM general.album al
	JOIN general.artist_band ab ON al.artist_id = ab.artist_id
	GROUP BY ab.music_genre
	ORDER BY album_count DESC;
END;
GO

-- 10. Lista dos 20 temas de álbuns mais longos
CREATE OR ALTER PROCEDURE sp_albunsmaislongos
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 20 Title, Duration
	FROM general.Track
	ORDER BY Duration DESC;
END;
GO

-- 11. Lista dos 20 temas de álbuns mais rápidos
CREATE OR ALTER PROCEDURE sp_albunsmaisrapidos
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 20 Title, Duration
	FROM general.Track
	ORDER BY Duration ASC;
END;
GO

-- 12. Lista dos 10 álbuns que demoram mais tempo
CREATE OR ALTER PROCEDURE sp_albunsdemoramtempo
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 10 al.album_name, SUM(t.Duration) AS total_duration
	FROM general.Track t
	JOIN general.album al ON t.album_id = al.album_id
	GROUP BY al.album_name
	ORDER BY total_duration DESC;
END;
GO

-- 13. Quantos temas tem cada álbum
CREATE OR ALTER PROCEDURE sp_temasalbum
AS
BEGIN
	SET NOCOUNT ON;

	SELECT al.album_name, COUNT(*) AS track_count
	FROM general.Track t
	JOIN general.album al ON t.album_id = al.album_id
	GROUP BY al.album_name;
END;
GO

-- 14. Quantos temas de álbuns demoram mais que 5 minutos
CREATE OR ALTER PROCEDURE sp_albunsmaiscincominutos
AS
BEGIN
	SET NOCOUNT ON;

	SELECT COUNT(Duration) AS tracks_longer_than_5_minutes
	FROM general.Track
	WHERE Duration > 300;
END;
GO

-- 15. Quais são as músicas mais ouvidas
CREATE OR ALTER PROCEDURE sp_musicasmaisouvidas
AS
BEGIN
	SET NOCOUNT ON;

	SELECT t.Title, COUNT(*) AS play_count
	FROM general.listen l
	JOIN general.Track t ON l.Track_ID = t.Track_ID
	GROUP BY t.Title
	ORDER BY play_count DESC;
END;
GO

-- 16. Quais são as músicas mais ouvidas, por país, entre as 00:00AM e as 08:00AM
CREATE OR ALTER PROCEDURE sp_maisouvidasporpaiszerooito
AS
BEGIN
	SET NOCOUNT ON;

	SELECT l.Country_listen, t.Title, COUNT(*) AS play_count
	FROM general.listen l
	JOIN general.Track t ON l.Track_ID = t.Track_ID
	WHERE CAST(l.Date_time AS TIME) BETWEEN '00:00:00' AND '08:00:00'
	GROUP BY l.Country_listen, t.Title
	ORDER BY l.Country_listen ASC, play_count DESC;
END;
GO

-- 17. Quais são as músicas mais ouvidas, por país, entre as 08:00 e as 16:00
CREATE OR ALTER PROCEDURE sp_maisouvidasporpaisoitodezasseis
AS
BEGIN
	SET NOCOUNT ON;

	SELECT l.Country_listen, t.Title, COUNT(*) AS play_count
	FROM general.listen l
	JOIN general.Track t ON l.Track_ID = t.Track_ID
	WHERE CAST(l.Date_time AS TIME) BETWEEN '08:00:00' AND '16:00:00'
	GROUP BY l.Country_listen, t.Title
	ORDER BY l.Country_listen ASC, play_count DESC;
END;
GO

-- 18. Qual o género musical mais ouvido por país
CREATE OR ALTER PROCEDURE sp_generomusicalpais
AS
BEGIN
	SET NOCOUNT ON;

	SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
	FROM general.listen l
	JOIN general.Track t ON l.Track_ID = t.Track_ID
	JOIN general.album al ON t.album_id = al.album_id
	JOIN general.artist_band ab ON al.artist_id = ab.artist_id
	GROUP BY l.Country_listen, ab.music_genre
	ORDER BY l.Country_listen ASC, genre_count DESC;
END;
GO

-- 19. Qual o género musical mais ouvido por país, entre as 00:00AM e as 08:00AM
CREATE OR ALTER PROCEDURE sp_generomaisouvidasporpaiszerooito
AS
BEGIN
	SET NOCOUNT ON;

	SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
	FROM general.listen l
	JOIN general.Track t ON l.Track_ID = t.Track_ID
	JOIN general.album al ON t.album_id = al.album_id
	JOIN general.artist_band ab ON al.artist_id = ab.artist_id
	WHERE CAST(l.Date_time AS TIME) BETWEEN '00:00:00' AND '08:00:00'
	GROUP BY l.Country_listen, ab.music_genre
	ORDER BY l.Country_listen ASC, genre_count DESC;
END;
GO

-- 20. Qual o género musical mais ouvido por país, entre as 16:00 e as 24:00
CREATE OR ALTER PROCEDURE sp_generomaisouvidasporpaisdezasseisvintequatro
AS
BEGIN
	SET NOCOUNT ON;

	SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
	FROM general.listen l
	JOIN general.Track t ON l.Track_ID = t.Track_ID
	JOIN general.album al ON t.album_id = al.album_id
	JOIN general.artist_band ab ON al.artist_id = ab.artist_id
	WHERE CAST(l.Date_time AS TIME) BETWEEN '16:00:00:000' AND '23:59:59:999'
	GROUP BY l.Country_listen, ab.music_genre
	ORDER BY l.Country_listen ASC, genre_count DESC;
END;
GO