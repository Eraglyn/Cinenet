import csv
import random
import datetime
from faker import Faker

# Initialisation de Faker pour la génération de données aléatoires
fake = Faker()

# Fonction pour générer un titre aléatoire entre 3 et 6 mots
def generate_title():
    return ' '.join(fake.words(random.randint(3, 6))).title()

# Fonction pour générer un synopsis aléatoire entre 10 et 20 mots
def generate_synopsis():
    return ' '.join(fake.sentences(random.randint(2, 5)))

# Lecture du fichier personne.csv pour obtenir les réalisateurs
realisateurs = []
with open('../CSV/personne.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        if row['metier'] == 'realisateur':
            realisateurs.append(row['idPers'])

# Vérification qu'il y a des réalisateurs dans le fichier
if not realisateurs:
    raise ValueError("Aucun réalisateur trouvé dans le fichier personne.csv.")

# Génération du fichier oeuvre.csv
with open('../CSV/oeuvre.csv', mode='w', newline='', encoding='utf-8') as file:
    fieldnames = ['idOeuv', 'idPers', 'idStud', 'titre', 'dateSortie', 'synopsis', 'noteMoyenne']
    writer = csv.DictWriter(file, fieldnames=fieldnames, delimiter=';')

    writer.writeheader()

    for idOeuv in range(1, 101):  # Génère 100 oeuvres par exemple
        idPers = random.choice(realisateurs)  # Choisir un réalisateur aléatoire
        idStud = random.randint(1, 20)  # Générer un idStud aléatoire entre 1 et 20
        titre = generate_title()  # Générer un titre aléatoire
        dateSortie = fake.date_between(start_date=datetime.date(1980, 1, 1), end_date=datetime.date.today()).strftime('%Y-%m-%d')  # Générer une date de sortie aléatoire
        synopsis = generate_synopsis()  # Générer un synopsis aléatoire
        noteMoyenne = 0  # Initialiser la note moyenne à 0

        # Écrire la ligne dans le fichier oeuvre.csv
        writer.writerow({
            'idOeuv': idOeuv,
            'idPers': idPers,
            'idStud': idStud,
            'titre': titre,
            'dateSortie': dateSortie,
            'synopsis': synopsis,
            'noteMoyenne': noteMoyenne
        })
