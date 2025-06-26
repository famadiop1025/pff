#!/usr/bin/env python
import os
import django

# Configuration Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_api.settings')
django.setup()

from django.contrib.auth.models import User
from vaccination.models import Profile

def changer_role_agent():
    try:
        # Trouver l'utilisateur agentDiop
        user = User.objects.get(username='agentDiop')
        
        # Changer son rôle en 'agent'
        profile = user.profile
        profile.role = 'agent'
        profile.save()
        
        print(f"✓ Rôle de {user.username} changé vers 'Agent de santé'")
        
    except User.DoesNotExist:
        print("Utilisateur 'agentDiop' non trouvé.")
    except Profile.DoesNotExist:
        print("Profil non trouvé pour 'agentDiop'.")

if __name__ == "__main__":
    changer_role_agent() 