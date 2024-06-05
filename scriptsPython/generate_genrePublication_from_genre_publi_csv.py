import csv
import random

# Lecture du fichier genre.csv
genres = []
with open('../CSV/genre.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        genres.append(row['idGen'])

# Lecture du fichier publication.csv
publications = []
with open('../CSV/publication.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        publications.append(row['idPub'])  # Assurez-vous que le fichier publication.csv a une colonne 'idPub'

# Génération du fichier genrePublication.csv
with open('../CSV/genrePublication.csv', mode='w', newline='', encoding='utf-8') as file:
    fieldnames = ['idPub', 'idGen']
    writer = csv.DictWriter(file, fieldnames=fieldnames, delimiter=';')

    writer.writeheader()

    # Utilisation d'un set pour stocker les associations uniques
    associations = set()

    for idPub in publications:
        # Déterminer un nombre aléatoire de genres pour cette publication (entre 1 et 3)
        num_genres = random.randint(1, 3)
        assigned_genres = random.sample(genres, num_genres)  # Choisir aléatoirement num_genres genres

        for idGen in assigned_genres:
            # Ajouter l'association uniquement si elle n'existe pas encore
            if (idPub, idGen) not in associations:
                writer.writerow({'idPub': idPub, 'idGen': idGen})
                associations.add((idPub, idGen))
