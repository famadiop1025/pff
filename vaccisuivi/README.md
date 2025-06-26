# VacciSuivi - Application de Suivi Vaccinal Infantile

## 📋 Description

VacciSuivi est une application Flutter complète pour le suivi de la vaccination infantile au Sénégal. Elle permet aux parents, tuteurs, agents de santé et administrateurs de gérer efficacement le suivi vaccinal des enfants.

## 🏗️ Architecture

### Backend (Django REST Framework)
- **Base de données** : SQLite avec modèles Village, Enfant, Vaccin, Profile
- **Authentification** : Token-based avec rôles (parent, tuteur, agent, admin)
- **API REST** : Endpoints pour toutes les opérations CRUD

### Frontend (Flutter)
- **Interface moderne** : Material Design avec thème vert
- **Navigation** : Sidebar dynamique selon le rôle utilisateur
- **Écrans multiples** : Dashboards spécialisés par rôle

## 👥 Rôles Utilisateurs

### 1. **Parent**
- Inscription d'enfants
- Suivi du statut vaccinal
- Consultation des rendez-vous
- Notifications

### 2. **Tuteur**
- Mêmes fonctionnalités que le parent
- Gestion de plusieurs enfants

### 3. **Agent de Santé**
- Gestion des enfants
- Planification de rendez-vous
- Suivi des vaccinations
- Notifications

### 4. **Administrateur**
- Gestion complète des utilisateurs
- Gestion des agents
- Gestion des parents/tuteurs
- Rapports et statistiques
- Gestion des enfants
- Rendez-vous urgents

## 📱 Écrans Implémentés

### Écrans Communs
- ✅ **Login Screen** - Authentification avec token
- ✅ **Notifications Screen** - Système de notifications par rôle
- ✅ **Sidebar** - Navigation dynamique

### Écrans Parent/Tuteur
- ✅ **Dashboard Parent/Tuteur** - Accueil personnalisé
- ✅ **Inscrire Enfant** - Formulaire d'inscription complet
- ✅ **Suivi Enfant** - Vue détaillée du statut vaccinal
- ✅ **Rendez-vous à Venir** - Gestion des RDV

### Écrans Agent
- ✅ **Dashboard Agent** - Accueil avec statistiques
- ✅ **Gestion Enfants** - Liste avec filtres et actions
- ✅ **Rendez-vous Urgents** - Gestion des RDV prioritaires
- ✅ **Statistiques** - Graphiques et métriques

### Écrans Administrateur
- ✅ **Dashboard Admin** - Vue d'ensemble complète
- ✅ **Gestion Utilisateurs** - CRUD utilisateurs avec filtres
- ✅ **Gestion Agents** - Gestion des agents de santé
- ✅ **Gestion Parents/Tuteurs** - Administration des familles
- ✅ **Rapports** - Statistiques avancées et graphiques

### Écrans Spécialisés
- ✅ **Fiche Enfant** - Vue détaillée avec historique vaccinal
- ✅ **Liste Enfants** - Liste avec filtres et recherche

## 🔧 Fonctionnalités Techniques

### Authentification
- Login avec token JWT
- Récupération du rôle et nom complet
- Redirection automatique selon le rôle
- Gestion des sessions

### Gestion des Données
- Appels API REST
- Données mock pour le développement
- Gestion d'erreurs
- Loading states

### Interface Utilisateur
- Design responsive
- Thème cohérent (vert #4CAF50)
- Animations fluides
- Feedback utilisateur (SnackBars)

### Filtres et Recherche
- Recherche textuelle
- Filtres par village
- Filtres par statut
- Filtres par rôle

## 📊 Modèles de Données

### Enfant
```dart
{
  id: String,
  nom: String,
  dateNaissance: String,
  lieuNaissance: String,
  sexe: String,
  age: int,
  village: String,
  groupeSanguin: String,
  allergies: String,
  antecedentsMedicaux: String,
  tauxCouverture: double,
  historiqueVaccins: List<Map>,
  prochainVaccin: Map?
}
```

### Utilisateur
```dart
{
  id: String,
  username: String,
  full_name: String,
  email: String,
  role: String,
  village: String,
  statut: String,
  date_inscription: String
}
```

## 🚀 Installation et Démarrage

### Prérequis
- Flutter SDK (version stable)
- Dart SDK
- Android Studio / VS Code

### Installation
```bash
# Cloner le projet
git clone [repository-url]
cd vaccisuivi

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run
```

### Configuration Backend
```bash
cd backend-pff
python -m venv env
source env/bin/activate  # Linux/Mac
# ou
env\Scripts\activate     # Windows

pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## 📱 Captures d'Écran

### Dashboard Administrateur
- Vue d'ensemble avec statistiques
- Menu latéral avec toutes les fonctionnalités
- Accès rapide aux rapports

### Gestion des Enfants
- Liste avec filtres avancés
- Recherche par nom/village
- Statuts visuels (complet/partiel/non vacciné)

### Fiche Enfant
- Informations détaillées
- Historique vaccinal complet
- Progression visuelle
- Actions rapides

## 🔮 Fonctionnalités Futures

### À Implémenter
- [ ] Export PDF des rapports
- [ ] Notifications push
- [ ] Synchronisation hors ligne
- [ ] Calendrier vaccinal personnalisé
- [ ] Rappels automatiques
- [ ] Intégration SMS

### Améliorations
- [ ] Mode sombre
- [ ] Multilingue (Wolof, Pulaar)
- [ ] Géolocalisation
- [ ] Photos des enfants
- [ ] Historique des modifications

## 🛠️ Technologies Utilisées

### Frontend
- **Flutter** - Framework UI
- **Dart** - Langage de programmation
- **Material Design** - Design system
- **HTTP** - Appels API
- **Shared Preferences** - Stockage local

### Backend
- **Django** - Framework web
- **Django REST Framework** - API REST
- **SQLite** - Base de données
- **JWT** - Authentification

## 📝 Notes de Développement

### Structure du Code
- **lib/screens/** - Écrans de l'application
- **lib/models/** - Modèles de données
- **lib/services/** - Services API et données
- **lib/widgets/** - Composants réutilisables

### Conventions
- Nommage en français pour les écrans
- Nommage en anglais pour les variables techniques
- Commentaires en français
- Documentation complète

### Tests
- Tests unitaires pour les modèles
- Tests d'intégration pour les services
- Tests widget pour l'interface

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👨‍💻 Auteur

Développé pour le suivi vaccinal infantile au Sénégal.

---

**VacciSuivi** - Simplifions le suivi vaccinal pour un avenir plus sain ! 💚
