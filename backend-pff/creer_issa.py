#!/usr/bin/env python
import os
import django

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_api.settings')
django.setup()

from django.contrib.auth.models import User
from vaccination.models import Profile

def creer_issa():
    try:
        # Vérifier si l'utilisateur existe déjà
        if User.objects.filter(username='issa').exists():
            print("L'utilisateur 'issa' existe déjà.")
            return
        
        # Créer l'utilisateur
        user = User.objects.create_user(
            username='issa',
            email='issa@gmail.com',
            password='admin12345'
        )
        
        # Mettre à jour le profil (créé automatiquement par le signal)
        profile = user.profile
        profile.role = 'parent'
        profile.save()
        
        print(f"✓ Utilisateur 'issa' créé avec le rôle 'Parent'")
        
    except Exception as e:
        print(f"Erreur lors de la création: {e}")

if __name__ == "__main__":
    creer_issa() 