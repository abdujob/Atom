# Restaurant Self-Service Terminal

## Description
Application Flutter pour terminal de self-service de restaurant, permettant aux clients de passer commande et d'effectuer le paiement.

## Architecture
- **Modèle**: MVC simplifié avec Provider pour la gestion d'état
- **Structure**: Organisation par couches (models, screens, widgets, data, constants)
- **Gestion d'état**: Provider (centralisé via Cart)

## Commandes utiles

### Développement
```bash
# Installation des dépendances
flutter pub get

# Lancer l'application
flutter run

# Tests
flutter test

# Tests avec couverture
flutter test --coverage

# Analyse du code
flutter analyze

# Formatage du code
dart format .

# Build
flutter build apk --release
```

### Structure du projet
```
lib/
├── constants/       # Constantes de l'application
├── data/           # Données statiques et mock
├── models/         # Modèles de données
├── screens/        # Écrans de l'application
├── widgets/        # Widgets réutilisables
└── main.dart       # Point d'entrée

test/
├── unit/           # Tests unitaires
└── widget_test.dart # Tests de widgets
```

## Fonctionnalités
- ✅ Navigation par catégories (Tacos, Burger, Pizza)
- ✅ Gestion du panier avec Provider
- ✅ Personnalisation des articles
- ✅ Paiement en espèces
- ❌ Paiement Wave Mobile (supprimé)
- ✅ Impression de tickets

## Configuration
- SDK Flutter: >=3.0.0 <4.0.0
- Plateforme cible: Android (terminal)
- Dépendances principales: Provider, Blue Thermal Printer, Permission Handler

## Tests
- Tests unitaires pour les modèles (Cart, CartItem)
- Tests de widgets pour les écrans principaux
- Couverture: ~85%

## Sécurité
- Pas de données sensibles stockées
- Communications locales uniquement
- Permissions limitées (Bluetooth pour impression)