\echo "—- une requête qui porte sur au moins trois tables ;"
\prompt 'Entrez un nom de film : ' t_film
\echo "voici les information sur l'oeuvre : " :'t_film'
-- Requête qui porte sur au moins trois tables
-- Cette requête récupère le titre d'une œuvre et le nom de 
-- son genre pour une œuvre spécifique, identifiée par son titre. 
-- Les jointures internes (JOIN) permettent de relier les tables Oeuvre, 
-- Film, GenreOeuvre et Genre afin de récupérer les informations pertinentes. 
-- La condition WHERE filtre les résultats pour inclure uniquement l'œuvre spécifiée.
SELECT Oeuvre.titre, Genre.nom 
FROM Oeuvre
JOIN Film ON Oeuvre.idOeuv = Film.idOeuv
JOIN GenreOeuvre ON GenreOeuvre.idOeuv = Oeuvre.idOeuv
JOIN Genre ON GenreOeuvre.idGen = Genre.idGen
WHERE Oeuvre.titre = :'t_film';

\echo "—- une ’auto jointure’ (jointure de deux copies d’une même table) ;"
\echo "voici toutes saisons d'une même série ayant le même nombre d'épisodes : "
-- Cette requête est une auto jointure qui récupère les saisons d'une même oeuvre ayant le même nombre d'épisodes.
-- La jointure permet de filtrer les saisons qui ont le même nombre d'épisodes et de récupérer le nom de la série.
SELECT DISTINCT Oeuvre.titre, S1.idOeuv, S1.numSaison, S1.nbEpisodes, S2.numSaison, S2.nbEpisodes
FROM Saison S1, Saison S2
JOIN Oeuvre ON S2.idOeuv = Oeuvre.idOeuv
WHERE S1.idOeuv = S2.idOEuv 
AND S1.numSaison < S2.numSaison
AND S1.nbEpisodes = S2.nbEpisodes;

\echo "-- une sous-requête corrélée ;"
\prompt "Entrez une année : " t_annee
\echo "voici toutes les utilisateurs qui ont ecrit au moins une publications apres cette annees : " :'t_annee'
-- Cette requête récupère les pseudos des utilisateurs qui ont publié quelque chose après 
-- l'année spécifiée par :t_annee. La condition WHERE EXISTS vérifie pour chaque utilisateur s'il 
-- existe au moins une publication dont l'année est postérieure à :t_annee. Si c'est le cas, le 
-- pseudo de cet utilisateur est sélectionné.
SELECT P1.Pseudo
FROM Utilisateur P1
WHERE EXISTS (
    SELECT 1
    FROM Publication Pub
    WHERE Pub.idUtil = P1.idUtil
    AND EXTRACT(YEAR FROM Pub.DatePubli) > :'t_annee'::int
);

\echo "—- une sous-requête dans le FROM ;"
\prompt "Entrez un genre : " t_genre
\echo "voici tous les films du genre et de ses sous-genres: " :'t_genre'
-- Cette requête récupère les titres des œuvres, leurs dates de sortie, et le nom d'un genre 
-- spécifique. Elle utilise une sous-requête pour filtrer les genres en fonction du nom du 
-- genre (:t_genre), puis fait des jointures pour associer les œuvres et leurs genres. La clause 
-- DISTINCT assure que les résultats ne contiennent pas de doublons.
SELECT Distinct Oeuvre.titre, Oeuvre.dateSortie, G.nom
FROM (SELECT G.idGen, G.nom FROM Genre G WHERE G.nom = :'t_genre') as G, GenreOeuvre, Oeuvre
WHERE Oeuvre.idOeuv = GenreOeuvre.idOeuv AND GenreOeuvre.idGen = G.idGen;

\echo "—- une sous-requête dans le WHERE ;"
\prompt "Entrez un genre : " t_genre
\echo "voici le film le plus recent du genre: " :'t_genre'
-- Cette requête récupère les titres et les dates de sortie des œuvres du genre spécifié 
-- (:t_genre) qui ont la date de sortie la plus récente. Elle utilise des jointures pour 
-- associer les œuvres avec leurs genres via la table de relation GenreOeuvre. La sous-requête 
-- est utilisée pour trouver la date de sortie maximale parmi toutes les œuvres.
SELECT Oeuvre.titre, Oeuvre.dateSortie FROM Oeuvre, GenreOeuvre, Genre 
WHERE Oeuvre.DateSortie = (SELECT MAX(DateSortie) FROM Oeuvre) 
AND Oeuvre.idOeuv = GenreOeuvre.idOeuv AND Genre.nom = :'t_genre';

\echo "—- deux agrégats nécessitant GROUP BY et HAVING ;"
\prompt "Entrez une année : " t_anne
\echo "Voici l'oeuvre les plus mentionnés en : " :'t_anne'
-- Cette requête identifie les œuvres qui ont été le plus mentionnées dans les publications 
-- pour une année donnée (:t_annee). Elle utilise des jointures pour associer les œuvres avec 
-- leurs mentions dans les publications. Le filtrage par année est réalisé avec la clause WHERE 
-- et l'agrégation des mentions est faite avec GROUP BY. La condition HAVING compare le nombre 
-- de mentions de chaque œuvre avec le nombre maximum de mentions pour l'année spécifiée, 
-- retournant ainsi l'œuvre la plus mentionnée.
SELECT Oeuvre.titre, COUNT(*) as nb
FROM Oeuvre
JOIN MentionOeuvre as MO ON Oeuvre.idOeuv = MO.idOeuv
JOIN Publication PU ON MO.idPub = PU.idPub
WHERE EXTRACT(YEAR FROM PU.DatePubli) = :'t_anne'::int
GROUP BY Oeuvre.titre
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*)
    FROM Oeuvre
    JOIN MentionOeuvre as MO ON Oeuvre.idOeuv = MO.idOeuv
    JOIN Publication PU ON MO.idPub = PU.idPub
    WHERE EXTRACT(YEAR FROM PU.DatePubli) = :'t_anne'::int
    GROUP BY Oeuvre.titre
);

\echo "-- une requête impliquant le calcul de deux agrégats (par exemple, les moyennes d’un ensemble de maximums) ;"
\echo "voici la serie la plus longue : "
-- Cette requête identifie l'œuvre ayant le plus grand nombre d'épisodes en utilisant des 
-- sous-requêtes imbriquées pour calculer et comparer les totaux d'épisodes par œuvre. 
-- Les sous-requêtes permettent de d'abord agrégater les données par œuvre et de trouver le 
-- maximum parmi ces agrégats. Ensuite, la requête principale sélectionne les titres des 
-- œuvres et leurs totaux d'épisodes, en filtrant pour ne garder que l'œuvre ayant le total 
-- maximal.
SELECT O.titre, S.total_episodes
FROM Oeuvre O
JOIN (
    SELECT idOeuv, SUM(nbEpisodes) AS total_episodes
    FROM Saison
    GROUP BY idOeuv
) AS S ON O.idOeuv = S.idOeuv
WHERE S.total_episodes = (
    SELECT MAX(total_episodes)
    FROM (
        SELECT SUM(nbEpisodes) AS total_episodes
        FROM Saison
        GROUP BY idOeuv
    ) AS TotalEpisodes
);

\echo "-- une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN) ;"
\echo "les utilisateurs et leurs nombres de notations : "
-- Cette requête liste tous les utilisateurs et le nombre de notations qu'ils ont faites. 
-- Pour les utilisateurs qui n'ont pas fait de notations, la requête retourne 0 grâce à la 
-- fonction COALESCE. Une jointure externe gauche est utilisée pour s'assurer que tous les
-- utilisateurs sont inclus dans les résultats, même ceux sans notations.
SELECT U.pseudo, COALESCE(S.notations, 0) AS total_notations
FROM Utilisateur U
LEFT JOIN (
    SELECT idUtil, COUNT(*) AS notations FROM Note GROUP BY idUtil
) AS S ON U.idUtil = S.idUtil;


\echo "deux requêtes équivalentes exprimant une condition de totalité, l’une avec des sous requêtes corrélées et l’autre avec de l’agrégation ;"
\echo "sous-requête corrélée : "
SELECT O.titre
FROM Oeuvre O
WHERE EXISTS (
    SELECT 1
    FROM Saison S
    WHERE S.idOeuv = O.idOeuv
);

\echo "agrégation : "
SELECT O.titre
FROM Oeuvre O
JOIN Saison S ON O.idOeuv = S.idOeuv
GROUP BY O.titre
HAVING COUNT(S.numSaison) > 0;


\echo "—- Une requête récursive (par exemple, une requête permettant de calculer quel est le prochain jour sans événement d’un cinéma) ;"
\echo "voici le prochain evenement : "
-- Cette requête trouve la prochaine date sans événement en vérifiant chaque jour
-- successivement à partir de la date actuelle. Elle utilise une requête récursive 
-- pour ajouter un jour à chaque itération et vérifier s'il y a un événement prévu pour 
-- cette nouvelle date.

-- En combinant ces éléments, la requête est capable de trouver et retourner la première date 
-- sans événement et d'inclure le nom de l'événement pour ce jour, s'il en existe un.
WITH RECURSIVE prochainEvent AS (
    SELECT CURRENT_DATE::timestamp AS prochain
    UNION ALL
    SELECT prochain + INTERVAL '1 day'
    FROM prochainEvent
    WHERE NOT EXISTS (
        SELECT 1
        FROM Evenement
        WHERE dateEven = prochain + INTERVAL '1 day'
    )
)
SELECT prochain::date
FROM prochainEvent
WHERE prochain > CURRENT_DATE
ORDER BY prochain
LIMIT 1;



\echo "-— Une requête utilisant le fenêtrage ;"
\echo 
SELECT idUtil, DatePubli, 
COUNT(*) OVER (PARTITION BY EXTRACT(MONTH FROM DatePubli) ORDER BY DatePubli) AS MonthlyCount
FROM Publication
WHERE EXTRACT(YEAR FROM DatePubli) = 2023;