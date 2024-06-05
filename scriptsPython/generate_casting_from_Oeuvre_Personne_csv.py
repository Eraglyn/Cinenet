import csv
import random

# Liste des métiers possibles
metiers = ['acteur', 'realisateur', 'scenariste', 'producteur', 'cadreur', 'doubleur', 'compositeur']

# Fonction pour générer un casting aléatoire pour une oeuvre
def generer_casting(id_oeuvre):
    casting = []
    for metier in metiers:
        # Sélection aléatoire d'une personne pour chaque métier
        personne = random.choice(personnes)
        # Ajout de la personne au casting
        tup = (personne['idPers'], id_oeuvre)
        if tup not in casting:
            casting.append(tup)
    for _ in range(random.randint(0,3)):
        personne = random.choice(personnes)
        tup = (personne['idPers'], id_oeuvre)
        if tup not in casting:
            casting.append(tup)
    return casting

# Chargement des données des fichiers CSV
with open('../CSV/personne.csv', newline='', encoding='utf-8') as file:
    personne_reader = csv.DictReader(file, delimiter=';')
    personnes = list(personne_reader)

with open('../CSV/oeuvre.csv', newline='', encoding='utf-8') as file:
    oeuvre_reader = csv.DictReader(file, delimiter=';')
    oeuvres = list(oeuvre_reader)

# Création du fichier casting.csv
with open('../CSV/casting.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file, delimiter=';')
    writer.writerow(['idPers', 'idOeuv'])

    for oeuvre in oeuvres:
        id_oeuvre = oeuvre['idOeuv']
        casting = generer_casting(id_oeuvre)
        writer.writerows(casting)

print("Fichier casting.csv généré avec succès.")
