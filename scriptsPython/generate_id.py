import pandas as pd

# Charger les données depuis un fichier CSV
data = pd.read_csv("../CSV/studio.csv", sep=";")

# Ajouter une colonne idP représentant la clé primaire
data.insert(0, "idStud", range(1, len(data) + 1))

# Enregistrer les données dans un nouveau fichier CSV
data.to_csv("../CSV/studio.csv", index=False, sep=";")
