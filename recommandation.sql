\prompt "Entrez un idUtil : " userId
\echo "Voici les oeuvres que vous n'avez pas noté et que vous serez susceptible d'aimer : "
WITH UserGenres AS (
    SELECT DISTINCT gp.idGen
    FROM publication p
    JOIN GenrePublication gp ON p.idPub = gp.idPub
    WHERE p.idUtil = :userId
    UNION
    SELECT DISTINCT g.idGen
    FROM note n
    JOIN oeuvre o ON n.idOeuv = o.idOeuv
    JOIN genreOeuvre gp ON o.idOeuv = gp.idOeuv
    JOIN genre g ON gp.idGen = g.idGen
    WHERE n.idUtil = :userId AND n.note > 60
),
SousUserGenre AS (
    SELECT DISTINCT sg.idGEnfant
    FROM SousGenre sg
    JOIN UserGenres ug ON sg.idGParent = ug.idGen
    WHERE gp.idGen IN (SELECT idGen FROM UserGenres)
)
SELECT DISTINCT o.titre
FROM UserGenres ug, SousUserGenre sug, Genre g 
JOIN GenreOeuvre go ON g.idGen = go.idGen 
JOIN Oeuvre o ON go.idOeuv = o.idOeuv
WHERE ug.idGen = g.idGen OR sug.idGenfant = g.idGen