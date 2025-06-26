#!/usr/bin/env python
import os
import django

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_api.settings')
django.setup()

from django.contrib.auth.models import User
from vaccination.models import Profile

def afficher_roles():
    print("=== UTILISATEURS ET LEURS RÔLES ===\n")
    
    # Récupérer tous les utilisateurs avec leurs profils
    users = User.objects.all()
    
    if not users.exists():
        print("Aucun utilisateur trouvé dans la base de données.")
        return
    
    print(f"{'ID':<5} {'Nom d\'utilisateur':<20} {'Email':<30} {'Rôle':<15}")
    print("-" * 70)
    
    for user in users:
        try:
            profile = user.profile
            role = profile.get_role_display()  # Affiche le nom lisible du rôle
        except Profile.DoesNotExist:
            role = "Aucun profil"
        
        print(f"{user.id:<5} {user.username:<20} {user.email:<30} {role:<15}")
    
    print("\n" + "="*70)
    
    # Statistiques par rôle
    print("\n=== STATISTIQUES PAR RÔLE ===")
    roles_count = {}
    for user in users:
        try:
            role = user.profile.role
            roles_count[role] = roles_count.get(role, 0) + 1
        except Profile.DoesNotExist:
            roles_count['sans_profil'] = roles_count.get('sans_profil', 0) + 1
    
    for role, count in roles_count.items():
        if role == 'sans_profil':
            print(f"Sans profil: {count}")
        else:
            role_display = dict(Profile.USER_ROLES).get(role, role)
            print(f"{role_display}: {count}")

if __name__ == "__main__":
    afficher_roles() 