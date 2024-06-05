import csv
import random

def generate_episodes_with_durations(input_file, output_file):
    with open(input_file, 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=';')
        fieldnames = ['idO', 'numSaison', 'numEpisode', 'duree']
        episodes = []

        for row in reader:
            idO = row['idO']
            numSaison = row['numSaison']
            nbEpisode = int(row['nbEpisode'])
            duree = random.randint(10, 60)  # Génère une durée aléatoire entre 10 et 60 minutes
            
            for numEpisode in range(1, nbEpisode + 1):
                episodes.append({
                    'idO': idO,
                    'numSaison': numSaison,
                    'numEpisode': numEpisode,
                    'duree': duree
                })

    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=';')
        writer.writeheader()
        writer.writerows(episodes)

# Utilisation : spécifiez le chemin du fichier d'entrée et de sortie
input_file = '../CSV/saison.csv'
output_file = '../CSV/episode.csv'
generate_episodes_with_durations(input_file, output_file)
