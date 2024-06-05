import csv
import random

# Lecture du fichier genre.csv
genres = []
with open('../CSV/genre.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        genres.append(row['idGen'])

# Lecture du fichier evenement.csv
evenements = []
with open('../CSV/evenement.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        evenements.append(row['idEven'])

# Génération du fichier genreEvenement.csv
with open('../CSV/genreEvenement.csv', mode='w', newline='', encoding='utf-8') as file:
    fieldnames = ['idEven', 'idGen']
    writer = csv.DictWriter(file, fieldnames=fieldnames, delimiter=';')

    writer.writeheader()

    # Utilisation d'un set pour stocker les associations uniques
    associations = set()

    for idEven in evenements:
        # Déterminer un nombre aléatoire de genres pour cet événement (entre 1 et 3)
        num_genres = random.randint(1, 3)
        assigned_genres = random.sample(genres, num_genres)  # Choisir aléatoirement num_genres genres

        for idGen in assigned_genres:
            # Ajouter l'association uniquement si elle n'existe pas encore
            if (idEven, idGen) not in associations:
                writer.writerow({'idEven': idEven, 'idGen': idGen})
                associations.add((idEven, idGen))
