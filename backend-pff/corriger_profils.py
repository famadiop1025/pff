#!/usr/bin/env python
import os
import django

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_api.settings')
django.setup()

from django.contrib.auth.models import User
from vaccination.models import Profile

def corriger_profils_manquants():
    print("=== CORRECTION DES PROFILS MANQUANTS ===\n")
    
    users = User.objects.all()
    profils_crees = 0
    
    for user in users:
        try:
            # Vérifier si l'utilisateur a déjà un profil
            profile = user.profile
            print(f"✓ {user.username} a déjà un profil (rôle: {profile.get_role_display()})")
        except Profile.DoesNotExist:
            # Créer un profil pour l'utilisateur
            profile = Profile.objects.create(user=user, role='parent')
            profils_crees += 1
            print(f"✓ Profil créé pour {user.username} avec le rôle 'Parent'")
    
    print(f"\n=== RÉSULTAT ===")
    print(f"Profils créés: {profils_crees}")
    print(f"Total utilisateurs: {users.count()}")

if __name__ == "__main__":
    corriger_profils_manquants() 