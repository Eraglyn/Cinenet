import csv

# Charger les données du fichier CSV genre.csv
genres = []

with open("../CSV/genre.csv", newline='', encoding='utf-8') as file:
    reader = csv.DictReader(file, delimiter=';')
    for row in reader:
        genres.append(row)

# Créer une liste pour stocker les relations parent-enfant
relations = []

# Parcourir chaque genre
for genre in genres:
    nom_genre = genre["nom"]
    id_genre = genre["idG"]
    
    # Vérifier si le genre est un parent
    if " - " not in nom_genre:
        id_parent = id_genre
    else:
        # Si le genre a un "-",
        # alors il a un parent et un enfant
        parent, enfant = nom_genre.split(" - ")
        print(f"Parent: {parent}, Enfant: {enfant}")  # Afficher les noms pour débogage
        id_parent = [g["idG"] for g in genres if g["nom"] == parent][0]
        print(f"ID Parent: {id_parent}")  # Afficher l'ID du parent pour débogage
        id_enfant = id_genre
        print(f"ID Enfant: {id_enfant}")  # Afficher l'ID de l'enfant pour débogage
        
        # Ajouter la relation parent-enfant à la liste
        relations.append({"idGPar": id_parent, "idGEnf": id_enfant})

# Écrire les relations dans un fichier CSV
with open("../CSV/sous_genre.csv", "w", newline='', encoding='utf-8') as file:
    writer = csv.DictWriter(file, fieldnames=["idGPar", "idGEnf"], delimiter=';')
    writer.writeheader()
    writer.writerows(relations)
