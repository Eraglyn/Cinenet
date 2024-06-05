import csv
import random

# Charger les données des fichiers CSV
publications = []
emojis = []
utilisateurs = []

# Charger les publications
with open("../CSV/publication.csv", newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        publications.append(row)

# Charger les emojis
with open("../CSV/emoji.csv", newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        emojis.append(row)

# Charger les utilisateurs
with open("../CSV/utilisateur.csv", newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        utilisateurs.append(row)

# Créer une liste pour stocker les réactions
reactions = []

# Parcourir chaque publication
for publication in publications:
    # Choisir aléatoirement un emoji et un utilisateur
    emoji = random.choice(emojis)
    utilisateur = random.choice(utilisateurs)
    
    # Créer une réaction
    reaction = {
        "idE": emoji["idE"],
        "idP": publication["idP"],
        "idU": utilisateur["idU"]
    }
    
    # Ajouter la réaction à la liste
    reactions.append(reaction)

# Écrire les réactions dans un fichier CSV
with open("../CSV/reaction.csv", "w", newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=["idE", "idP", "idU"], delimiter=';')
    writer.writeheader()
    writer.writerows(reactions)
