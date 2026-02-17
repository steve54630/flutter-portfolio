# Portfolio - Steve

Un portfolio moderne et robuste développé avec **Flutter**, mettant en avant mes projets, mes compétences et mon expérience. Ce projet a été conçu avec une attention particulière portée à l'architecture logicielle et à la qualité du code (TDD).

## 🚀 Fonctionnalités

* **Profil Complet** : Bio, localisation et contacts interactifs.
* **Parcours Expérientiel** : Liste détaillée des expériences professionnelles.
* **Projets** : Galerie de projets avec filtrage par compétences.
* **Compétences (Skills)** : Visualisation des Hard et Soft skills.
* **Mode Responsive** : Adapté pour le Web, Mobile et Desktop.

## 🏗️ Architecture

Le projet suit les principes de la **Clean Architecture** pour garantir la testabilité et la maintenance :

lib/
├── data/
│   └── repositories/      # Implémentations des dépôts (Logique JSON)
├── domain/
│   ├── entities/          # Objets métier simplifiés
│   ├── exceptions/        # Gestion des erreurs personnalisées
│   ├── models/            # Modèles de données (Data mapping)
│   ├── repositories/      # Interfaces (Contrats) des dépôts
│   └── usescases/         # Logique applicative (Interactions)
└── presentation/
│    ├── pages/            # Écrans complets de l'application
│   ├── providers/         # Gestion d'état (Provider)
│    └── widgets/          # Composants UI réutilisables
└── shared/                # Code partagé au niveau domaine

## 🛠️ Stack Technique

* **Framework** : [Flutter 3.x](https://flutter.dev)
* **Gestion d'état** : [Provider](https://pub.dev/packages/provider)
* **Fonts** : Google Fonts (Poppins, Aleo)
* **Icons** : FontAwesome / Material Icons
* **Navigation** : GoRouter (ou Flutter Navigator)

## 🧪 Tests & Qualité

La qualité est au cœur de ce projet avec un objectif de couverture de code élevé.

* **Tests Unitaires** : Validation des modèles et des Use Cases.
* **Tests de Données** : Mocks avancés du `BinaryMessenger` pour tester les sources JSON.
* **Couverture actuelle** : **~91%** (LCOV).

### Lancer les tests
```bash
flutter test
```

Générer le rapport de coverage

```bash
flutter test --coverage
```

## 📦 Installation et lancement

### 1. Cloner le projet

```bash
git clone https://github.com/steve54630/flutter_portfolio
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Lancer l'application

```bash
flutter run
```

## 📝 Configuration des données

Les données du portfolio sont centralisées dans des fichiers JSON situés dans assets/data/. Il suffit de modifier ces fichiers pour mettre à jour le contenu sans toucher au code source.