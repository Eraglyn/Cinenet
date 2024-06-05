import csv
import random

# Lecture du fichier genre.csv
genres = []
with open('../CSV/genre.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        genres.append(row['idGen'])

# Lecture du fichier oeuvre.csv
oeuvres = []
with open('../CSV/oeuvre.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        oeuvres.append(row['idOeuv'])

# Génération du fichier genreOeuvre.csv
with open('../CSV/genreOeuvre.csv', mode='w', newline='', encoding='utf-8') as file:
    fieldnames = ['idOeuv', 'idGen']
    writer = csv.DictWriter(file, fieldnames=fieldnames, delimiter=';')

    writer.writeheader()

    # Utilisation d'un set pour stocker les associations uniques
    associations = set()

    for idOeuv in oeuvres:
        # Déterminer un nombre aléatoire de genres pour cette oeuvre (entre 1 et 3 par exemple)
        num_genres = random.randint(1, 3)
        assigned_genres = random.sample(genres, num_genres)  # Choisir aléatoirement num_genres genres

        for idGen in assigned_genres:
            # Ajouter l'association uniquement si elle n'existe pas encore
            if (idOeuv, idGen) not in associations:
                writer.writerow({'idOeuv': idOeuv, 'idGen': idGen})
                associations.add((idOeuv, idGen))
