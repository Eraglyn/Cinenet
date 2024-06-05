import csv

# Nom du fichier d'entrée et de sortie
input_file = "../CSV/input.csv"
output_file = "../CSV/output.csv"

# Ouvrir le fichier CSV en lecture
with open(input_file, newline='', encoding='utf-8') as csvfile:
    # Lire le fichier CSV
    reader = csv.reader(csvfile)
    
    # Extraire les données sans la première colonne
    data = [row[1:] for row in reader]

# Écrire les données dans un nouveau fichier CSV
with open(output_file, "w", newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerows(data)

print("La première colonne a été supprimée avec succès.")
