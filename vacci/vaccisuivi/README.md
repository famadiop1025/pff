# Frontend Flutter – VacciSuivi

Ce dossier contient l'application mobile/web Flutter pour le suivi de la vaccination infantile en milieu rural au Sénégal.

VacciSuivi est une application mobile Flutter dédiée au suivi de la vaccination infantile en milieu rural au Sénégal. Elle permet aux agents de santé de gérer efficacement les dossiers vaccinaux des enfants et de suivre la couverture vaccinale.

## 🎯 Fonctionnalités

### 🔐 Authentification
- Page de connexion sécurisée
- Interface adaptée aux agents de santé

### 📊 Tableau de Bord
- Statistiques globales (nombre d'enfants, taux de couverture)
- Prochains rendez-vous vaccinaux
- Actions rapides vers les principales fonctionnalités

### 👥 Gestion des Enfants
- **Liste des enfants** avec filtres par village et statut vaccinal
- **Recherche** par nom ou village
- **Ajout d'enfant** avec formulaire complet
- **Fiche détaillée** de chaque enfant

### 💉 Suivi Vaccinal
- Historique complet des vaccins reçus
- Ajout de nouveaux vaccins administrés
- Prochains vaccins à prévoir
- Statuts vaccinaux (complet, partiel, non vacciné)

### 📈 Statistiques
- Graphiques de couverture vaccinale par village
- Répartition des statuts vaccinaux
- Visualisations interactives avec fl_chart

### 🤖 Assistant Intelligent
- Chatbot intégré avec réponses simulées
- Questions fréquentes sur la vaccination
- Interface de chat intuitive
- Icône flottante accessible depuis toutes les pages

## 🛠️ Technologies Utilisées

- **Flutter** 3.7.2+ (multi-plateforme Android/iOS)
- **Dart** (langage de programmation)
- **fl_chart** (graphiques et visualisations)
- **provider** (gestion d'état)
- **intl** (localisation et formatage)

## 📁 Structure du Projet

```
vaccisuivi/
  lib/                # Code source principal (Dart)
  pubspec.yaml        # Dépendances Flutter
  android/            # Projet Android natif
  ios/                # Projet iOS natif
  web/                # Fichiers pour le déploiement web
  ...
```

## Prérequis
- Flutter SDK (3.x recommandé)
- Un éditeur compatible (VS Code, Android Studio, etc.)
- Un appareil ou un émulateur (Android/iOS/Web)

## Installation

1. **Se placer dans le dossier Flutter**
   ```bash
   cd vaccisuivi
   ```
2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

## Lancer l'application

- **Sur mobile (Android/iOS) :**
  ```bash
  flutter run
  ```
- **Sur le web :**
  ```bash
  flutter run -d chrome
  ```

## Configuration de l'API

L'application consomme l'API Django (backend). Par défaut, l'URL de l'API est :
```dart
static const String baseUrl = 'http://localhost:8000/api';
```
- Pour tester sur un vrai appareil, remplace `localhost` par l'IP de la machine qui héberge le backend.
- Modifie ce paramètre dans `lib/services/api_service.dart` si besoin.

## Fonctionnalités principales
- Authentification (mock)
- Tableau de bord avec statistiques
- Liste des enfants avec filtres (village, statut vaccinal, recherche)
- Ajout d'un enfant
- Fiche détaillée d'un enfant (historique vaccinal, prochain vaccin)
- Statistiques avec graphiques
- Rappels visuels
- Chatbot intégré (réponses prédéfinies)

## Conseils
- Pour un hot reload : appuie sur `r` dans le terminal où tourne `flutter run`.
- Pour générer le code JSON après modification des modèles :
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- Pour changer la langue ou le thème, adapte le code dans `main.dart`.

---

**Contact :** Pour toute question, voir la documentation du projet ou contacter le développeur principal.
