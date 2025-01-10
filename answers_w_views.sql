-- Switch to 'music' database
USE music;
GO

-- 1. Lista alfabética de utilizadores
CREATE OR ALTER VIEW Q1 AS(
SELECT [name]
FROM general.[user]);

SELECT *
FROM Q1
ORDER BY [name] ASC;

-- 2. Lista alfabética de Géneros musicais
CREATE OR ALTER VIEW Q2 AS(
SELECT DISTINCT music_genre
FROM general.artist_band);

SELECT *
FROM Q2
ORDER BY music_genre ASC;

-- 3. Lista alfabética de Etiquetas/Labels
CREATE OR ALTER VIEW Q3 AS(
SELECT DISTINCT [label]
FROM general.album);

SELECT *
FROM Q3
ORDER BY [label] ASC;

-- 4. Lista alfabética de bandas, por países
CREATE OR ALTER VIEW Q4 AS(
SELECT name_artist, country_artist
FROM general.artist_band);

SELECT *
FROM Q4
ORDER BY country_artist ASC, name_artist ASC;

-- 5. Lista alfabética de banda, label, género, nome álbum
CREATE OR ALTER VIEW Q5 AS(
SELECT 
    ab.name_artist AS band_name, 
    al.[label], 
    ab.music_genre, 
    al.album_name
FROM general.album al
JOIN general.artist_band ab ON al.artist_id = ab.artist_id);

SELECT *
FROM Q5
ORDER BY band_name ASC, [label] ASC, music_genre ASC, album_name ASC;

-- 6. Lista dos 5 países com mais bandas
CREATE OR ALTER VIEW Q6 AS(
SELECT country_artist, COUNT(*) AS band_count
FROM general.artist_band
GROUP BY country_artist);

SELECT TOP 5 *
FROM Q6
ORDER BY band_count DESC;

-- 7. Lista das 10 bandas com mais álbuns
CREATE OR ALTER VIEW Q7 AS(
SELECT ab.name_artist, COUNT(*) AS album_count
FROM general.album al
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
GROUP BY ab.name_artist);

SELECT TOP 10 *
FROM Q7
ORDER BY album_count DESC;

-- 8. Lista das 5 etiquetas com mais álbuns
CREATE OR ALTER VIEW Q8 AS(
SELECT al.[label], COUNT(*) AS album_count
FROM general.album al
GROUP BY al.[label]);

SELECT TOP 5 *
FROM Q8
ORDER BY album_count DESC;

-- 9. Lista dos 5 géneros musicais com mais álbuns
CREATE OR ALTER VIEW Q9 AS(
SELECT ab.music_genre, COUNT(*) AS album_count
FROM general.album al
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
GROUP BY ab.music_genre);

SELECT TOP 5 *
FROM Q9
ORDER BY album_count DESC;

-- 10. Lista dos 20 temas de álbuns mais longos
CREATE OR ALTER VIEW Q10 AS(
SELECT Title, Duration
FROM general.Track);

SELECT TOP 20 *
FROM Q10
ORDER BY Duration DESC;

-- 11. Lista dos 20 temas de álbuns mais rápidos
CREATE OR ALTER VIEW Q11 AS(
SELECT Title, Duration
FROM general.Track);

SELECT TOP 20*
FROM Q11
ORDER BY Duration ASC;

-- 12. Lista dos 10 álbuns que demoram mais tempo
CREATE OR ALTER VIEW Q12 AS(
SELECT al.album_name, SUM(t.Duration) AS total_duration
FROM general.Track t
JOIN general.album al ON t.album_id = al.album_id
GROUP BY al.album_name);

SELECT TOP 10 *
FROM Q12
ORDER BY total_duration DESC;

-- 13. Quantos temas tem cada álbum
CREATE OR ALTER VIEW Q13 AS(
SELECT al.album_name, COUNT(*) AS track_count
FROM general.Track t
JOIN general.album al ON t.album_id = al.album_id
GROUP BY al.album_name);

SELECT *
FROM Q13

-- 14. Quantos temas de álbuns demoram mais que 5 minutos
CREATE OR ALTER VIEW Q14 AS(
SELECT COUNT(Duration) AS tracks_longer_than_5_minutes
FROM general.Track
WHERE Duration > 300);

SELECT *
FROM Q14

-- 15. Quais são as músicas mais ouvidas
CREATE OR ALTER VIEW Q15 AS(
SELECT t.Title, COUNT(*) AS play_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
GROUP BY t.Title);

SELECT *
FROM Q15
ORDER BY play_count DESC;

-- 16. Quais são as músicas mais ouvidas, por país, entre as 00:00AM e as 08:00AM
CREATE OR ALTER VIEW Q16 AS(
SELECT l.Country_listen, t.Title, COUNT(*) AS play_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
WHERE CAST(l.Date_time AS TIME) BETWEEN '00:00:00' AND '08:00:00'
GROUP BY l.Country_listen, t.Title);

SELECT *
FROM Q16
ORDER BY Country_listen ASC, play_count DESC;

-- 17. Quais são as músicas mais ouvidas, por país, entre as 08:00 e as 16:00
CREATE OR ALTER VIEW Q17 AS(
SELECT l.Country_listen, t.Title, COUNT(*) AS play_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
WHERE CAST(l.Date_time AS TIME) BETWEEN '08:00:00' AND '16:00:00'
GROUP BY l.Country_listen, t.Title);

SELECT *
FROM Q17
ORDER BY Country_listen ASC, play_count DESC;

-- 18. Qual o género musical mais ouvido por país
CREATE OR ALTER VIEW Q18 AS(
SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
GROUP BY l.Country_listen, ab.music_genre);

SELECT *
FROM Q18
ORDER BY Country_listen ASC, genre_count DESC;

-- 19. Qual o género musical mais ouvido por país, entre as 00:00AM e as 08:00AM
CREATE OR ALTER VIEW Q19 AS(
SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
WHERE CAST(l.Date_time AS TIME) BETWEEN '00:00:00' AND '08:00:00'
GROUP BY l.Country_listen, ab.music_genre);

SELECT *
FROM Q19
ORDER BY Country_listen ASC, genre_count DESC;

-- 20. Qual o género musical mais ouvido por país, entre as 16:00 e as 24:00
CREATE OR ALTER VIEW Q20 AS(
SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
WHERE CAST(l.Date_time AS TIME) BETWEEN '16:00:00:000' AND '23:59:59:999'
GROUP BY l.Country_listen, ab.music_genre);

SELECT *
FROM Q20
ORDER BY Country_listen ASC, genre_count DESC;