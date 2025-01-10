-- Switch to 'music' database
USE music;
GO

-- 1. Lista alfab�tica de utilizadores
SELECT [name]
FROM general.[user]
ORDER BY [name] ASC;

-- 2. Lista alfab�tica de G�neros musicais
SELECT DISTINCT music_genre
FROM general.artist_band
ORDER BY music_genre ASC;

-- 3. Lista alfab�tica de Etiquetas/Labels
SELECT DISTINCT [label]
FROM general.album
ORDER BY [label] ASC;

-- 4. Lista alfab�tica de bandas, por pa�ses
SELECT name_artist, country_artist
FROM general.artist_band
ORDER BY country_artist ASC, name_artist ASC;

-- 5. Lista alfab�tica de banda, label, g�nero, nome �lbum
SELECT 
    ab.name_artist AS band_name, 
    al.[label], 
    ab.music_genre, 
    al.album_name
FROM general.album al
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
ORDER BY ab.name_artist ASC, al.[label] ASC, ab.music_genre ASC, al.album_name ASC;

-- 6. Lista dos 5 pa�ses com mais bandas
SELECT TOP 5 country_artist, COUNT(*) AS band_count
FROM general.artist_band
GROUP BY country_artist
ORDER BY band_count DESC;

-- 7. Lista das 10 bandas com mais �lbuns
SELECT TOP 10 ab.name_artist, COUNT(*) AS album_count
FROM general.album al
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
GROUP BY ab.name_artist
ORDER BY album_count DESC;

-- 8. Lista das 5 etiquetas com mais �lbuns
SELECT TOP 5 al.[label], COUNT(*) AS album_count
FROM general.album al
GROUP BY al.[label]
ORDER BY album_count DESC;

-- 9. Lista dos 5 g�neros musicais com mais �lbuns
SELECT TOP 5 ab.music_genre, COUNT(*) AS album_count
FROM general.album al
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
GROUP BY ab.music_genre
ORDER BY album_count DESC;

-- 10. Lista dos 20 temas de �lbuns mais longos
SELECT TOP 20 Title, Duration
FROM general.Track
ORDER BY Duration DESC;

-- 11. Lista dos 20 temas de �lbuns mais r�pidos
SELECT TOP 20 Title, Duration
FROM general.Track
ORDER BY Duration ASC;

-- 12. Lista dos 10 �lbuns que demoram mais tempo
SELECT TOP 10 al.album_name, SUM(t.Duration) AS total_duration
FROM general.Track t
JOIN general.album al ON t.album_id = al.album_id
GROUP BY al.album_name
ORDER BY total_duration DESC;

-- 13. Quantos temas tem cada �lbum
SELECT al.album_name, COUNT(*) AS track_count
FROM general.Track t
JOIN general.album al ON t.album_id = al.album_id
GROUP BY al.album_name;

-- 14. Quantos temas de �lbuns demoram mais que 5 minutos
SELECT COUNT(Duration) AS tracks_longer_than_5_minutes
FROM general.Track
WHERE Duration > 300;

-- 15. Quais s�o as m�sicas mais ouvidas
SELECT t.Title, COUNT(*) AS play_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
GROUP BY t.Title
ORDER BY play_count DESC;

-- 16. Quais s�o as m�sicas mais ouvidas, por pa�s, entre as 00:00AM e as 08:00AM
SELECT l.Country_listen, t.Title, COUNT(*) AS play_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
WHERE CAST(l.Date_time AS TIME) BETWEEN '00:00:00' AND '08:00:00'
GROUP BY l.Country_listen, t.Title
ORDER BY l.Country_listen ASC, play_count DESC;

-- 17. Quais s�o as m�sicas mais ouvidas, por pa�s, entre as 08:00 e as 16:00
SELECT l.Country_listen, t.Title, COUNT(*) AS play_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
WHERE CAST(l.Date_time AS TIME) BETWEEN '08:00:00' AND '16:00:00'
GROUP BY l.Country_listen, t.Title
ORDER BY l.Country_listen ASC, play_count DESC;

-- 18. Qual o g�nero musical mais ouvido por pa�s
SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
GROUP BY l.Country_listen, ab.music_genre
ORDER BY l.Country_listen ASC, genre_count DESC;

-- 19. Qual o g�nero musical mais ouvido por pa�s, entre as 00:00AM e as 08:00AM
SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
WHERE CAST(l.Date_time AS TIME) BETWEEN '00:00:00' AND '08:00:00'
GROUP BY l.Country_listen, ab.music_genre
ORDER BY l.Country_listen ASC, genre_count DESC;

-- 20. Qual o g�nero musical mais ouvido por pa�s, entre as 16:00 e as 24:00
SELECT l.Country_listen, ab.music_genre, COUNT(*) AS genre_count
FROM general.listen l
JOIN general.Track t ON l.Track_ID = t.Track_ID
JOIN general.album al ON t.album_id = al.album_id
JOIN general.artist_band ab ON al.artist_id = ab.artist_id
WHERE CAST(l.Date_time AS TIME) BETWEEN '16:00:00:000' AND '23:59:59:999'
GROUP BY l.Country_listen, ab.music_genre
ORDER BY l.Country_listen ASC, genre_count DESC;