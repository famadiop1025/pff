#!/usr/bin/env python
import os
import django

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_api.settings')
django.setup()

from django.contrib.auth.models import User
from vaccination.models import Profile

def afficher_menu():
    print("\n=== GESTION DES RÔLES ===")
    print("1. Voir tous les utilisateurs et leurs rôles")
    print("2. Changer le rôle d'un utilisateur")
    print("3. Créer un nouvel utilisateur avec un rôle")
    print("4. Voir les statistiques par rôle")
    print("5. Quitter")
    print("=" * 30)

def voir_utilisateurs():
    print("\n=== UTILISATEURS ET LEURS RÔLES ===")
    users = User.objects.all()
    
    if not users.exists():
        print("Aucun utilisateur trouvé.")
        return
    
    print(f"{'ID':<5} {'Nom d\'utilisateur':<20} {'Email':<30} {'Rôle':<15}")
    print("-" * 70)
    
    for user in users:
        try:
            profile = user.profile
            role = profile.get_role_display()
        except Profile.DoesNotExist:
            role = "Aucun profil"
        
        print(f"{user.id:<5} {user.username:<20} {user.email:<30} {role:<15}")

def changer_role():
    print("\n=== CHANGER LE RÔLE D'UN UTILISATEUR ===")
    
    # Afficher les utilisateurs
    users = User.objects.all()
    if not users.exists():
        print("Aucun utilisateur trouvé.")
        return
    
    print("Utilisateurs disponibles:")
    for user in users:
        try:
            role = user.profile.get_role_display()
        except Profile.DoesNotExist:
            role = "Aucun profil"
        print(f"{user.id}. {user.username} - {role}")
    
    # Demander l'ID de l'utilisateur
    try:
        user_id = int(input("\nEntrez l'ID de l'utilisateur: "))
        user = User.objects.get(id=user_id)
    except (ValueError, User.DoesNotExist):
        print("ID utilisateur invalide.")
        return
    
    # Afficher les rôles disponibles
    print("\nRôles disponibles:")
    for code, nom in Profile.USER_ROLES:
        print(f"- {code}: {nom}")
    
    # Demander le nouveau rôle
    nouveau_role = input("\nEntrez le nouveau rôle (parent/tuteur/agent/admin): ").lower()
    
    if nouveau_role not in [code for code, _ in Profile.USER_ROLES]:
        print("Rôle invalide.")
        return
    
    # Mettre à jour le rôle
    try:
        profile = user.profile
        profile.role = nouveau_role
        profile.save()
        print(f"✓ Rôle de {user.username} changé vers '{dict(Profile.USER_ROLES)[nouveau_role]}'")
    except Profile.DoesNotExist:
        profile = Profile.objects.create(user=user, role=nouveau_role)
        print(f"✓ Profil créé pour {user.username} avec le rôle '{dict(Profile.USER_ROLES)[nouveau_role]}'")

def creer_utilisateur():
    print("\n=== CRÉER UN NOUVEL UTILISATEUR ===")
    
    username = input("Nom d'utilisateur: ")
    email = input("Email: ")
    password = input("Mot de passe: ")
    
    # Vérifier si l'utilisateur existe déjà
    if User.objects.filter(username=username).exists():
        print("Ce nom d'utilisateur existe déjà.")
        return
    
    # Créer l'utilisateur
    user = User.objects.create_user(username=username, email=email, password=password)
    
    # Afficher les rôles disponibles
    print("\nRôles disponibles:")
    for code, nom in Profile.USER_ROLES:
        print(f"- {code}: {nom}")
    
    # Demander le rôle
    role = input("\nEntrez le rôle (parent/tuteur/agent/admin): ").lower()
    
    if role not in [code for code, _ in Profile.USER_ROLES]:
        print("Rôle invalide. Rôle par défaut 'parent' assigné.")
        role = 'parent'
    
    # Mettre à jour le profil existant (créé automatiquement par le signal)
    try:
        profile = user.profile
        profile.role = role
        profile.save()
        print(f"✓ Utilisateur {username} créé avec le rôle '{dict(Profile.USER_ROLES)[role]}'")
    except Profile.DoesNotExist:
        # Si le profil n'existe pas (cas rare), le créer
        profile = Profile.objects.create(user=user, role=role)
        print(f"✓ Utilisateur {username} créé avec le rôle '{dict(Profile.USER_ROLES)[role]}'")

def statistiques():
    print("\n=== STATISTIQUES PAR RÔLE ===")
    users = User.objects.all()
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

def main():
    while True:
        afficher_menu()
        choix = input("\nVotre choix (1-5): ")
        
        if choix == '1':
            voir_utilisateurs()
        elif choix == '2':
            changer_role()
        elif choix == '3':
            creer_utilisateur()
        elif choix == '4':
            statistiques()
        elif choix == '5':
            print("Au revoir !")
            break
        else:
            print("Choix invalide. Veuillez réessayer.")

if __name__ == "__main__":
    main() 