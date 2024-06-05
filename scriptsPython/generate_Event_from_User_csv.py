import csv
import random
from faker import Faker
from datetime import datetime, date

# Initialisation de Faker pour la génération de données aléatoires
fake = Faker()

# Fonction pour générer un nom d'événement aléatoire entre 1 et 6 mots
def generate_event_name():
    return ' '.join(fake.words(random.randint(1, 6))).title()

# Fonction pour générer une description aléatoire entre 10 et 20 mots
def generate_description():
    return ' '.join(fake.sentences(random.randint(2, 5)))

# Lecture du fichier utilisateur.csv pour obtenir les utilisateurs avec le rôle 'orga'
organisateurs = []
with open('../CSV/utilisateur.csv', mode='r', newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        if row['role'] == 'orga':
            organisateurs.append(row['idUtil'])

# Vérification qu'il y a des organisateurs dans le fichier
if not organisateurs:
    raise ValueError("Aucun organisateur trouvé dans le fichier utilisateur.csv.")

# Définir les dates de début et de fin comme des objets datetime.date
start_date = date(2003, 1, 1)
end_date = date(2030, 12, 31)

# Génération du fichier evenement.csv
with open('../CSV/evenement.csv', mode='w', newline='', encoding='utf-8') as file:
    fieldnames = ['idEven', 'idUtil', 'nom', 'date', 'duree', 'description', 'nbPlaces', 'prix', 'statut']
    writer = csv.DictWriter(file, fieldnames=fieldnames, delimiter=';')

    writer.writeheader()

    for idEven in range(1, 101):  # Génère 100 événements par exemple
        idUtil = random.choice(organisateurs)  # Choisir un organisateur aléatoire
        nom = generate_event_name()  # Générer un nom d'événement aléatoire
        dateSortie = fake.date_between(start_date=start_date, end_date=end_date).strftime('%Y-%m-%d')  # Générer une date d'événement aléatoire
        duree = random.randint(1, 7)  # Générer une durée aléatoire entre 1 et 7 jours
        description = generate_description()  # Générer une description aléatoire
        nbPlaces = random.randint(50, 500)  # Générer un nombre de places aléatoire entre 50 et 500
        prix = random.uniform(20, 100)  # Générer un prix aléatoire entre 20 et 100
        prix = round(prix, 2)  # Arrondir le prix à deux décimales

        # Déterminer le statut en fonction de la date de l'événement
        event_date = datetime.strptime(dateSortie, '%Y-%m-%d')
        statut = 'fini' if event_date < datetime.today() else 'bientot'

        # Écrire la ligne dans le fichier evenement.csv
        writer.writerow({
            'idEven': idEven,
            'idUtil': idUtil,
            'nom': nom,
            'date': dateSortie,
            'duree': duree,
            'description': description,
            'nbPlaces': nbPlaces,
            'prix': prix,
            'statut': statut
        })
