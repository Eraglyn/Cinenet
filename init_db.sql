DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE IF NOT EXISTS Personne (
    idPers SERIAL PRIMARY KEY,
    prenom VARCHAR(100),
    nom VARCHAR(100),
    metier VARCHAR(100) CHECK (metier IN ('acteur', 'realisateur', 'scenariste', 'cadreur', 'doubleur', 'compositeur')),
    dateNaissance DATE,
    nbOscars INTEGER
);

CREATE TABLE IF NOT EXISTS Utilisateur (
    idUtil SERIAL PRIMARY KEY,
    pseudo VARCHAR(255) NOT NULL,
    mdp VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    perm VARCHAR(50) NOT NULL CHECK (perm IN ('admin', 'user', 'orga'))
);

CREATE TABLE IF NOT EXISTS Studio (
    idStud SERIAL PRIMARY KEY,
    nom VARCHAR(255),
    dateCreation DATE,
    ville VARCHAR(255),
    pays VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Genre (
    idGen SERIAL PRIMARY KEY,
    nom VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS SousGenre (
    idGParent INTEGER REFERENCES Genre(idGen),
    idGEnfant INTEGER REFERENCES Genre(idGen),
    UNIQUE (idGParent, idGEnfant)
);

CREATE TABLE IF NOT EXISTS Evenement (
    idEven SERIAL PRIMARY KEY,
    idUtil INTEGER REFERENCES Utilisateur(idUtil),
    nom VARCHAR(255) NOT NULL,
    dateEven TIMESTAMP NOT NULL,
    duree INTEGER NOT NULL, 
    description TEXT,
    nbPlaces INTEGER NOT NULL,
    prix DECIMAL(10, 2),
    statut VARCHAR(50) CHECK (statut IN ('bientot', 'fini'))
);

CREATE TABLE IF NOT EXISTS Oeuvre (
    idOeuv SERIAL PRIMARY KEY,
    idPers INTEGER REFERENCES Personne(idPers),
    idStud INTEGER REFERENCES Studio(idStud),
    titre VARCHAR(255) NOT NULL,
    dateSortie DATE,
    synopsis TEXT,
    noteMoyenne INTEGER
);  

CREATE TABLE IF NOT EXISTS Film (
    idOeuv INTEGER PRIMARY KEY REFERENCES Oeuvre(idOeuv),
    duree INTEGER
);

CREATE TABLE IF NOT EXISTS Serie (
    idOeuv INTEGER PRIMARY KEY REFERENCES Oeuvre(idOeuv),
    nbSaisons INTEGER
);

CREATE TABLE IF NOT EXISTS Saison (
    idSais SERIAL PRIMARY KEY,
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    numSaison INTEGER,
    nbEpisodes INTEGER
);

CREATE TABLE IF NOT EXISTS Episode (
    idEpi SERIAL PRIMARY KEY,
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    numSaison INTEGER,
    numEpisode INTEGER,
    duree INTEGER
);

CREATE TABLE IF NOT EXISTS Casting (
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    idPers INTEGER REFERENCES Personne(idPers),
    PRIMARY KEY (idOeuv, idPers)
);

CREATE TABLE IF NOT EXISTS Publication (
    idPub SERIAL PRIMARY KEY,
    idUtil INTEGER REFERENCES Utilisateur(idUtil),
    titre VARCHAR(255),
    datePubli TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    contenu TEXT,
    pieceJointes TEXT
);

CREATE TABLE IF NOT EXISTS Emoji(
    idEmo SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    code VARCHAR(50),
    descr TEXT
);

CREATE TABLE IF NOT EXISTS Reaction (
    idEmo INTEGER REFERENCES Emoji(idEmo),
    idPub INTEGER REFERENCES Publication(idPub),
    idUtil INTEGER REFERENCES Utilisateur(idUtil)
);

CREATE TABLE IF NOT EXISTS Inscription (
    idEven INTEGER REFERENCES Evenement(idEven),
    idUtil INTEGER REFERENCES Utilisateur(idUtil),
    PRIMARY KEY (idEven, idUtil)
);

CREATE TABLE IF NOT EXISTS Follow (
    idSuiveur INTEGER REFERENCES Utilisateur(idUtil),
    idSuivi INTEGER REFERENCES Utilisateur(idUtil),
    PRIMARY KEY (idSuiveur, idSuivi)
);

CREATE TABLE IF NOT EXISTS OeuvreEvent (
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    idEven INTEGER REFERENCES Evenement(idEven),
    PRIMARY KEY (idOeuv, idEven)
);

CREATE TABLE IF NOT EXISTS Note (
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    idUtil INTEGER REFERENCES Utilisateur(idUtil),
    note INTEGER CHECK (note BETWEEN 0 AND 100),
    PRIMARY KEY (idOeuv, idUtil)
);

CREATE TABLE IF NOT EXISTS Reponse (
    idPPar INTEGER REFERENCES Publication(idPub),
    idPenf INTEGER REFERENCES Publication(idPub),
    PRIMARY KEY (idPPar, idPenf)
);

CREATE TABLE IF NOT EXISTS GenreOeuvre (
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    idGen INTEGER REFERENCES Genre(idGen),
    PRIMARY KEY (idOeuv, idGen)
);

CREATE TABLE IF NOT EXISTS GenreEvenement(
    idEven INTEGER REFERENCES Evenement(idEven),
    idGen INTEGER REFERENCES Genre(idGen),
    PRIMARY KEY (idEven, idGen)
);

CREATE TABLE IF NOT EXISTS GenrePublication(
    idPub INTEGER REFERENCES Publication(idPub),
    idGen INTEGER REFERENCES Genre(idGen),
    PRIMARY KEY (idPub, idGen)
);

CREATE TABLE IF NOT EXISTS MentionOeuvre(
    idOeuv INTEGER REFERENCES Oeuvre(idOeuv),
    idPub INTEGER REFERENCES Publication(idPub),
    PRIMARY KEY (idOeuv, idPub)
);

CREATE TABLE IF NOT EXISTS MentionPersonne(
    idPers INTEGER REFERENCES Personne(idPers),
    idPub INTEGER REFERENCES Publication(idPub),
    PRIMARY KEY (idPers, idPub)
);

CREATE TABLE IF NOT EXISTS MentionUtilisateur(
    idUtil INTEGER REFERENCES Utilisateur(idUtil),
    idPub INTEGER REFERENCES Publication(idPub),
    PRIMARY KEY (idUtil, idPub)
);

-- les events doivent etre créer par des organisateurs
CREATE OR REPLACE FUNCTION check_orga_event() 
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT perm FROM Utilisateur WHERE idUtil = NEW.idUtil) != 'orga' THEN
        RAISE EXCEPTION 'Organisateur manquant';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_orga_event
BEFORE INSERT ON Evenement
FOR EACH ROW
EXECUTE FUNCTION check_orga_event();

-- les oeuvres doivent etre créer par des realisateurs
CREATE OR REPLACE FUNCTION check_realisateur() 
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT Metier FROM Personne WHERE idPers = NEW.idPers) != 'realisateur' THEN
        RAISE EXCEPTION 'Realisateur manquant';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_realisateur
BEFORE INSERT OR UPDATE ON Oeuvre
FOR EACH ROW
EXECUTE FUNCTION check_realisateur();

-- Créer la fonction pour mettre à jour la note moyenne d'une œuvre
CREATE OR REPLACE FUNCTION update_average_rating()
RETURNS TRIGGER AS $$
BEGIN
    -- Mettre à jour la note moyenne de l'œuvre en fonction des nouvelles notes
    UPDATE Oeuvre
    SET noteMoyenne = (
        SELECT AVG(note)
        FROM Note
        WHERE idOeuv = NEW.idOeuv
    )
    WHERE idOeuv = NEW.idOeuv;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer le déclencheur pour déclencher la fonction avant l'insertion d'une nouvelle note
CREATE TRIGGER trg_update_average_rating
AFTER INSERT ON Note
FOR EACH ROW
EXECUTE FUNCTION update_average_rating();

-- PEUPLAGE

\copy Personne FROM 'csv/personne.csv' DELIMITER ';' CSV HEADER;
\copy Utilisateur FROM 'csv/utilisateur.csv' DELIMITER ';' CSV HEADER;
\copy Studio FROM 'csv/studio.csv' DELIMITER ';' CSV HEADER;
\copy Genre FROM 'csv/genre.csv' DELIMITER ';' CSV HEADER;
\copy SousGenre FROM 'csv/sousGenre.csv' DELIMITER ';' CSV HEADER;
\copy Oeuvre FROM 'csv/oeuvre.csv' DELIMITER ';' CSV HEADER;
\copy Film FROM 'csv/film.csv' DELIMITER ';' CSV HEADER;
\copy Serie FROM 'csv/serie.csv' DELIMITER ';' CSV HEADER;
\copy Saison(idOeuv, numSaison, nbEpisodes) FROM 'csv/saison.csv' DELIMITER ';' CSV HEADER;
\copy Episode FROM 'csv/episode.csv' DELIMITER ';' CSV HEADER;
\copy Casting FROM 'csv/casting.csv' DELIMITER ';' CSV HEADER;
\copy Publication FROM 'csv/publication.csv' DELIMITER ';' CSV HEADER;
\copy Emoji FROM 'csv/emoji.csv' DELIMITER ';' CSV HEADER;
\copy Reaction FROM 'csv/reaction.csv' DELIMITER ';' CSV HEADER;
\copy Reponse FROM 'csv/reponse.csv' DELIMITER ';' CSV HEADER;
\copy Evenement FROM 'csv/evenement.csv' DELIMITER ';' CSV HEADER;
\copy Follow FROM 'csv/follow.csv' DELIMITER ';' CSV HEADER;
\copy Inscription FROM 'csv/inscription.csv' DELIMITER ';' CSV HEADER;
\copy MentionOeuvre FROM 'csv/mentionOeuvre.csv' DELIMITER ';' CSV HEADER;
\copy MentionPersonne FROM 'csv/mentionPersonne.csv' DELIMITER ';' CSV HEADER;
\copy MentionUtilisateur FROM 'csv/mentionUtilisateur.csv' DELIMITER ';' CSV HEADER;
\copy Note FROM 'csv/note.csv' DELIMITER ';' CSV HEADER;
\copy OeuvreEvent FROM 'csv/oeuvreEvent.csv' DELIMITER ';' CSV HEADER;
\copy GenreOeuvre FROM 'csv/genreOeuvre.csv' DELIMITER ';' CSV HEADER;
\copy GenreEvenement FROM 'csv/genreEvenement.csv' DELIMITER ';' CSV HEADER;
\copy GenrePublication FROM 'csv/genrePublication.csv' DELIMITER ';' CSV HEADER;