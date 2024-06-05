import csv
import random

def generate_follow_relations(users_file, follow_file, num_relations=100):
    with open(users_file, 'r', newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=';')
        next(reader)  # Skip header row
        users = list(reader)
        
    user_ids = list(range(1, len(users) + 1))
    
    follow_relations = []
    while len(follow_relations) < num_relations:
        idSuiveur = random.choice(user_ids)
        idSuivi = random.choice(user_ids)
        
        if idSuiveur != idSuivi:
            relation = (idSuiveur, idSuivi)
            
            if relation not in follow_relations:
                follow_relations.append(relation)
    
    with open(follow_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=';')
        writer.writerow(['idSuiveur', 'idSuivi'])
        writer.writerows(follow_relations)

# Utilisation : spécifiez le chemin du fichier d'entrée et de sortie
users_file = '../CSV/utilisateur.csv'
follow_file = '../CSV/follow.csv'
generate_follow_relations(users_file, follow_file)
