# <p align="center">✈️ Air Cadet Training ✈️</p>

<div align="center">
  <img src="https://github.com/Noralya/Air_Cadet_Training/blob/main/assets/logo.png" alt="Air Cadet Logo" width="180">
</div>

<h3 align="center">A Flutter App for Air France Cadets Training</h3>

<p align="center">
  🇫🇷 Bienvenue sur <b>Air Cadet Training</b> ! Une application Flutter d'entraînement aux épreuves de sélection des cadets Air France (PSY0 / PSY1).
  Fonctionne entièrement hors ligne, sans compte ni authentification.
</p>

<p align="center">
  🇬🇧 Welcome to <b>Air Cadet Training</b>! A Flutter application designed to train for Air France Cadet selection exercises (PSY0 / PSY1).
  The application works entirely offline, without an account or authentication.
</p>

---

## **📋 Table of Contents**

* [📚 Project Overview](#-project-overview)
* [🎯 Features](#-features)
* [🧠 Exercises](#-exercises)
* [📜 Stack technique](#-stack-technique)
* [🧱 Structure du projet](#-structure-du-projet)
* [⚙️ Compilation & Setup](#%EF%B8%8F-compilation--setup)
* [🖥️ Running the application](#%EF%B8%8F-running-the-application)
* [📊 Statistics & Progression](#-statistics--progression)
* [🔄 Work in Progress](#-work-in-progress)
* [🧰 Resources](#-resources)

---

## **📚 Project Overview**

**Air Cadet Training** est une application mobile Flutter permettant de s'entraîner aux différents types d'épreuves cognitives, spatiales, numériques, verbales et psychomotrices rencontrées lors des sélections des cadets Air France.

L'application est conçue pour fonctionner **entièrement hors ligne**.

Aucune connexion Internet, aucun compte utilisateur et aucun serveur ne sont nécessaires pour utiliser les fonctionnalités principales.

### Objectifs

* S'entraîner individuellement sur des exercices ciblés.
* Reproduire des conditions proches des épreuves PSY0 et PSY1.
* Utiliser des questions générées aléatoirement.
* Respecter les contraintes de temps propres à chaque exercice.
* Obtenir des corrections immédiates pendant l'entraînement.
* Effectuer des simulations complètes sans correction pendant l'épreuve.
* Suivre ses performances dans le temps.
* Identifier ses points faibles.
* Générer des entraînements personnalisés à partir des performances enregistrées.

### Modes disponibles

#### Entraînement

L'utilisateur sélectionne un exercice et peut le pratiquer de manière répétée.

```text
Exercise
   ↓
Question
   ↓
Answer
   ↓
Correction
   ↓
Next Question
```

La correction est affichée après chaque question.

#### Simulation PSY0

Une simulation regroupe exclusivement les exercices PSY0 disponibles.

Les exercices sont mélangés et aucune correction n'est affichée pendant la session.

Les résultats sont présentés à la fin de l'épreuve.

#### Simulation PSY1

Même fonctionnement que la simulation PSY0, mais exclusivement avec les exercices PSY1.

PSY0 et PSY1 ne sont jamais mélangés au sein d'une même simulation.

---

## **🎯 Features**

### Core

* Génération aléatoire des questions.
* Validation des réponses.
* Gestion des tentatives.
* Chronométrage spécifique aux exercices.
* Scoring.
* Gestion des sessions.
* Persistance locale des données.
* Statistiques.
* Analyse des performances.
* Recommandations d'entraînement.

### Offline First

L'application ne dépend d'aucun backend.

Les données sont conservées localement :

* paramètres ;
* historique des sessions ;
* tentatives ;
* statistiques ;
* progression.

### Difficulty

Il n'existe aucun choix de difficulté dans l'application.

Les exercices sont conçus directement avec leur niveau de difficulté cible.

La progression est mesurée par l'amélioration des performances :

* taux de réussite ;
* temps de réponse ;
* nombre d'erreurs ;
* régularité ;
* évolution dans le temps.

### Randomization

Les questions sont générées aléatoirement.

Le projet ne conserve pas de mémoire globale de toutes les questions générées.

Lorsque cela est pertinent, les générateurs disposent cependant de mécanismes spécifiques permettant d'éviter des répétitions triviales au sein d'une même session.

---

## **🧠 Exercises**

Les catégories sont présentes dans l'application dès le début, même lorsqu'elles ne contiennent encore aucun exercice.

### PSY0

* Numérique
* Attention
* Spatiale
* Verbale
* Psychomoteur
* Anglais
* Intellectuelle
* Connaissances aéronautiques
* Mémorisation

### PSY1

* Numérique
* Intellectuelle
* Attention
* Psychomoteur
* Spatiale
* Verbale
* Mémorisation

### Current exercises

#### PSY0 — Pair ou impair

**Category:** Numérique

Des nombres sont présentés à l'utilisateur.

À partir du nombre identifié par `START`, l'utilisateur doit sélectionner alternativement :

```text
Pair → Impair → Pair → Impair → ...
```

Les nombres sélectionnés doivent respecter un ordre croissant au sein de chaque catégorie.

En cas d'erreur, la série doit être recommencée depuis le début.

Les performances enregistrées comprennent notamment :

* réussite ;
* temps de réponse ;
* erreurs ;
* temps total de la série.

#### PSY0 — Memory Back Colors

**Category:** Mémorisation

Une couleur est affichée pendant une seconde.

Elle disparaît ensuite et les boutons suivants apparaissent pendant 1,5 seconde :

```text
[ Oui ]    [ Non ]
```

L'utilisateur doit répondre :

* `Oui` si la couleur affichée juste avant est identique à celle affichée deux couleurs auparavant ;
* `Non` dans le cas contraire.

Les deux premières couleurs servent à initialiser la mémoire et ne nécessitent aucune réponse.

Une absence de réponse est considérée comme une erreur.

Les performances enregistrées comprennent notamment :

* réponses correctes ;
* erreurs ;
* absences de réponse ;
* temps de réponse.

#### PSY1 — Angles

**Category:** Spatiale

Une montre affichant les chiffres `3`, `6`, `9` et `12` est présentée afin d'indiquer le sens direct de rotation.

Cinq propositions d'angles sont ensuite présentées.

Pour chaque situation :

* `O` représente l'origine ;
* `A` représente l'arrivée ;
* une valeur d'angle est donnée ;
* l'utilisateur doit sélectionner la proposition correspondant à la valeur et au sens de rotation indiqué.

Les performances enregistrées comprennent notamment :

* réponse ;
* réussite ;
* temps de réponse.

### Adding new exercises

L'architecture est conçue pour permettre l'ajout progressif de nouveaux exercices.

Un nouvel exercice doit principalement définir ses propres :

* règles ;
* générateur ;
* validation ;
* interface ;
* chronométrage ;
* scoring.

L'ajout d'un exercice ne doit pas nécessiter de modification importante du moteur central.

---

## **📜 Stack technique**

### Application

* **Flutter** — framework mobile et cross-platform.
* **Dart** — langage de programmation.

### Platforms

Le projet cible principalement :

* Android ;
* iOS.

Une cible Linux est également utilisée pendant le développement afin de tester rapidement l'application sur ordinateur.

Le Web peut également être utilisé pour certains tests d'interface lorsque nécessaire.

### Architecture

L'application est organisée autour de plusieurs responsabilités :

* Exercise Engine
* Session Engine
* Timer
* Statistics
* Recommendations
* Persistence
* Features
* Exercises

### Principles

Le projet suit notamment les principes suivants :

* séparation des responsabilités ;
* modularité ;
* forte utilisation du typage Dart ;
* logique métier indépendante de l'interface lorsque possible ;
* composants réutilisables ;
* génération procédurale ;
* stockage local ;
* optimisation des ressources.

---

## **🧱 Structure du projet**

```text
air_cadet_training/
├── README.md
├── assets/
│   └── logo.png
├── lib/
│   ├── core/
│   │   ├── engine/
│   │   │   ├── Exercise
│   │   │   ├── ExerciseMeta
│   │   │   ├── Attempt
│   │   │   ├── ExerciseRegistry
│   │   │   └── Timer
│   │   ├── persistence/
│   │   │   ├── StorageService
│   │   │   ├── SessionRecord
│   │   │   ├── AppSettings
│   │   │   └── SettingsProvider
│   │   ├── statistics/
│   │   │   ├── StatisticsEngine
│   │   │   ├── StatisticsProvider
│   │   │   └── models
│   │   ├── recommendations/
│   │   │   └── RecommendationEngine
│   │   └── theme/
│   │       └── AppTheme
│   ├── features/
│   │   ├── home/
│   │   ├── training/
│   │   ├── simulation/
│   │   ├── statistics/
│   │   └── settings/
│   ├── exercises/
│   │   ├── pair_ou_impair/
│   │   ├── memory_back_colors/
│   │   ├── angles/
│   │   └── exercises_bootstrap.dart
│   └── main.dart
├── android/
├── ios/
├── linux/
├── test/
└── pubspec.yaml
```

### Exercise architecture

Chaque exercice suit le modèle général :

```text
Exercise
    ↓
Question
    ↓
Attempt
    ↓
Result
    ↓
Statistics
    ↓
Performance Analysis
    ↓
Recommendation
```

Une distinction claire est conservée entre :

* **Exercise** : définition et mécanique de l'exercice ;
* **Question / Exercise Instance** : occurrence générée d'un exercice ;
* **Attempt** : interaction de l'utilisateur ;
* **Result** : résultat calculé à partir de la tentative.

---

## **⚙️ Compilation & Setup**

### Requirements

Pour développer le projet, il est nécessaire de disposer de :

* Flutter ;
* Dart fourni avec Flutter ;
* Android SDK pour Android ;
* Java pour Android ;
* un environnement de développement compatible Flutter.

### Flutter

Le projet utilise actuellement Flutter **3.47.4** sur l'environnement de développement WSL2.

Vérifier l'installation :

```bash
flutter --version
flutter doctor
```

Si la commande `flutter` n'est pas disponible correctement dans l'environnement courant, le chemin absolu vers le SDK Flutter peut être utilisé :

```bash
/home/noralia/flutter/bin/flutter
```

### Create / configure platforms

Pour générer les plateformes Android et iOS :

```bash
/home/noralia/flutter/bin/flutter create . --platforms=android,ios
```

Pour ajouter Linux afin de tester l'application directement sur ordinateur :

```bash
/home/noralia/flutter/bin/flutter create . --platforms=linux
```

Il est également possible de générer plusieurs plateformes :

```bash
/home/noralia/flutter/bin/flutter create . --platforms=android,ios,linux,web
```

### Install dependencies

```bash
/home/noralia/flutter/bin/flutter pub get
```

### Build

Android :

```bash
/home/noralia/flutter/bin/flutter build apk
```

Linux :

```bash
/home/noralia/flutter/bin/flutter build linux
```

---

## **🖥️ Running the application**

### Linux desktop

Pour lancer l'application sur ordinateur pendant le développement :

```bash
/home/noralia/flutter/bin/flutter run -d linux
```

Le projet doit contenir le dossier :

```text
linux/
```

Pour l'ajouter :

```bash
/home/noralia/flutter/bin/flutter create . --platforms=linux
```

### Android

Afficher les appareils disponibles :

```bash
/home/noralia/flutter/bin/flutter devices
```

Puis lancer l'application sur un appareil Android disponible :

```bash
/home/noralia/flutter/bin/flutter run -d <device-id>
```

### Web

Si la plateforme Web est activée :

```bash
/home/noralia/flutter/bin/flutter run -d chrome
```

### iOS

La compilation et l'exécution iOS nécessitent un environnement macOS avec Xcode.

La plateforme iOS peut néanmoins être générée depuis le projet :

```bash
/home/noralia/flutter/bin/flutter create . --platforms=ios
```

---

## **📊 Statistics & Progression**

Les performances sont enregistrées localement et permettent de suivre la progression dans le temps.

### Global statistics

* nombre de questions ;
* nombre de sessions ;
* temps total d'entraînement ;
* taux de réussite ;
* temps moyen ;
* évolution générale.

### Category statistics

Pour chaque catégorie :

* taux de réussite ;
* temps moyen ;
* nombre de questions ;
* évolution.

### Exercise statistics

Pour chaque exercice :

* taux de réussite ;
* temps moyen ;
* meilleur temps ;
* nombre de tentatives ;
* évolution.

### Weakness analysis

Le système analyse les performances récentes afin d'identifier les domaines nécessitant davantage d'entraînement.

Cette analyse permet notamment de prendre en compte :

* les catégories faibles ;
* les exercices peu maîtrisés ;
* les exercices peu pratiqués.

### Personalized training

Les recommandations utilisent les performances enregistrées afin de générer des entraînements adaptés.

L'objectif est de consacrer davantage de temps aux domaines nécessitant encore du travail tout en conservant une pratique régulière des autres exercices.

---

## **🔄 Work in Progress**

Le développement suit plusieurs phases.

### Phase 1 — Foundations

* architecture ;
* navigation ;
* design system ;
* responsive ;
* stockage local.

**Status:** Implemented.

### Phase 2 — Exercise Engine

* exercices ;
* questions ;
* réponses ;
* tentatives ;
* randomisation ;
* timer ;
* scoring.

**Status:** Implemented.

### Phase 3 — Sessions

* entraînement ;
* simulation PSY0 ;
* simulation PSY1 ;
* corrections.

**Status:** Implemented.

### Phase 4 — Progression

* statistiques ;
* historique ;
* analyse des faiblesses ;
* recommandations ;
* entraînement personnalisé.

**Status:** Implemented.

### Phase 5 — Exercises

Les trois exercices initiaux sont fonctionnels :

* Pair ou impair — PSY0 / Numérique ;
* Memory Back Colors — PSY0 / Mémorisation ;
* Angles — PSY1 / Spatiale.

Toutes les catégories PSY0 et PSY1 sont présentes dans la navigation, y compris celles qui ne contiennent pas encore d'exercice.

Les catégories vides affichent :

```text
Aucun exercice disponible pour le moment
```

Les exercices supplémentaires seront ajoutés progressivement.

### Phase 6 — Optimization

À finaliser progressivement :

* profiling mémoire ;
* profiling CPU ;
* optimisation du rendu ;
* optimisation des widgets ;
* optimisation des assets ;
* réduction de la taille de l'application ;
* validation responsive sur différentes tailles d'écran ;
* validation finale des performances.


---

## **🧰 Resources**

- [Documentation Flutter](https://docs.flutter.dev/)
- [API Flutter](https://api.flutter.dev/)
- [Documentation Dart](https://dart.dev/)

---

## **📄 License**

Project developed for educational and portfolio purposes.
