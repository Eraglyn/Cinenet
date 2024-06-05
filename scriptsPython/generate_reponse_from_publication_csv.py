import csv
import random
from datetime import datetime

def generate_reponse_publication(publication_file, reponse_file, num_reponse=35):
    with open(publication_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=';')
        header = next(reader)  # Skip header row
        publis = list(reader)
        
    # Vérifier l'index de la colonne date
    date_index = 3  # Modifiez cet index en fonction de la position de la colonne date dans votre fichier CSV
    #print(f"Index de la colonne date : {date_index}")
    
    # Convertir les dates en objets datetime
    for publi in publis:
        try:
            publi[date_index] = datetime.strptime(publi[date_index], '%Y-%m-%d %H:%M:%S')  # Assumant que le format de la date est 'YYYY-MM-DD HH:MM:SS'
        except ValueError as e:
            print(f"Erreur de conversion de la date pour l'entrée {publi}: {e}")
            continue
        #print(publi[date_index])
    
    
    publi_ids = list(range(1, len(publis) + 1))
    
    publi_reponse = []
    while len(publi_reponse) < num_reponse:
        idParent = random.choice(publi_ids)
        idEnfant = random.choice(publi_ids)
        
        if idParent != idEnfant:
            parent_publi = publis[idParent - 1]
            enfant_publi = publis[idEnfant - 1]
            
            parent_date = parent_publi[date_index]
            enfant_date = enfant_publi[date_index]
            
            if isinstance(parent_date, datetime) and isinstance(enfant_date, datetime):
                if parent_date < enfant_date:
                    reponse = (idParent, idEnfant)
                    
                    if reponse not in publi_reponse:
                        publi_reponse.append(reponse)
            else:
                print(f"Les dates ne sont pas valides pour les publications {idParent} et {idEnfant}")
    
    with open(reponse_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=';')
        writer.writerow(['idPPar', 'idPEnf'])
        writer.writerows(publi_reponse)

# Utilisation : spécifiez le chemin du fichier d'entrée et de sortie
publication_file = '../CSV/publication.csv'
reponse_file = '../CSV/reponse.csv'
generate_reponse_publication(publication_file, reponse_file)
