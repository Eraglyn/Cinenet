import csv
import random

def generate_seasons(input_file, output_file):
    with open(input_file, 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=';')
        fieldnames = ['idO', 'numSaison', 'nbEpisode']
        seasons = []

        for row in reader:
            idO = row['idO']
            nbSaison = int(row['nbSaison'])
            
            for numSaison in range(1, nbSaison + 1):
                nbEpisode = random.randint(1, 25)  # Génère un nombre d'épisodes aléatoire entre 1 et 25
                seasons.append({
                    'idO': idO,
                    'numSaison': numSaison,
                    'nbEpisode': nbEpisode
                })

    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=';')
        writer.writeheader()
        writer.writerows(seasons)

# Utilisation : spécifiez le chemin du fichier d'entrée et de sortie
input_file = '../CSV/serie.csv'
output_file = '../CSV/saison.csv'
generate_seasons(input_file, output_file)
