import os
import django
import random
from datetime import date, timedelta

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_api.settings')
django.setup()

from vaccination.models import Village, Enfant, Vaccin

# Nettoyage
Vaccin.objects.all().delete()
Enfant.objects.all().delete()
Village.objects.all().delete()

villages_noms = ['Thiès', 'Mbour', 'Joal', 'Ngaparou', 'Popenguine']
villages = [Village.objects.create(nom=nom) for nom in villages_noms]

prenoms = ['Fatou', 'Moussa', 'Aissatou', 'Ibrahima', 'Mariama', 'Ousmane', 'Aminata', 'Mamadou', 'Fatima', 'Abdou']

vaccins_disponibles = [
    'BCG', 'DTC', 'Polio', 'Rougeole', 'Fièvre jaune', 'Hépatite B',
    'ROR', 'Pneumocoque', 'Rotavirus', 'Méningite'
]

for i in range(15):
    nom = f"{random.choice(prenoms)} {chr(65+i)}"
    sexe = random.choice(['M', 'F'])
    village = random.choice(villages)
    date_naissance = date.today() - timedelta(days=random.randint(100, 1800))
    enfant = Enfant.objects.create(nom=nom, sexe=sexe, village=village, date_naissance=date_naissance)

    nb_vaccins = random.randint(2, 8)
    vaccins_choisis = random.sample(vaccins_disponibles, nb_vaccins)
    for v_nom in vaccins_choisis:
        date_admin = date_naissance + timedelta(days=random.randint(30, 900))
        statut = random.choice(['recu', 'retard'])
        Vaccin.objects.create(
            enfant=enfant,
            nom=v_nom,
            date_administration=date_admin,
            statut=statut,
            notes='Administré sans problème' if statut == 'recu' else 'Retard dû à absence'
        )

print('Jeu de données de test généré avec succès !') 