# Backend Django – VacciSuivi

Ce dossier contient le backend de l'application VacciSuivi, développé avec Django et Django REST Framework.

## Structure du dossier

```
backend/
  backend_api/         # Projet Django principal
  vaccination/         # Application Django pour la gestion des vaccins et enfants
  db.sqlite3           # Base de données SQLite (test/démo)
  manage.py            # Commande de gestion Django
  populate_data.py     # Script pour générer des données de test réalistes
```

## Prérequis
- Python 3.8+
- pip
- (Optionnel) virtualenv ou venv

## Installation

1. **Se placer dans le dossier backend**
   ```bash
   cd backend
   ```
2. **Créer un environnement virtuel (recommandé)**
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   venv\Scripts\activate    # Windows
   ```
3. **Installer les dépendances**
   ```bash
   pip install -r requirements.txt
   ```
   *(Si requirements.txt n'existe pas, demande-le !)*

## Lancer le serveur de développement

```bash
python manage.py runserver
```

L'API sera accessible sur : http://localhost:8000/api/

## Générer des données de test

Pour remplir la base avec des villages, enfants et vaccins réalistes :
```bash
python populate_data.py
```

## Points d'API principaux
- `/api/enfants/` : liste et création d'enfants
- `/api/enfants/<id>/` : détail d'un enfant
- `/api/villages/` : liste des villages
- `/api/statistiques/` : statistiques globales

## Conseils
- Pour réinitialiser la base :
  ```bash
  rm db.sqlite3
  python manage.py migrate
  python populate_data.py
  ```
- Pour l'administration Django :
  ```bash
  python manage.py createsuperuser
  python manage.py runserver
  # puis aller sur http://localhost:8000/admin/
  ```

---

**Contact :** Pour toute question, voir la documentation du projet ou contacter le développeur principal. 