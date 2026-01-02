# Entrelacs

Application de gestion d'habitat partagé pour Les Tisseurs de Liens.

## Description

Entrelacs permet aux **Tisseurs** (gestionnaires de résidences) de suivre les activités sociales de leur résidence et aux **Administrateurs** de superviser l'ensemble via des statistiques.

### Fonctionnalités principales

- **Gestion des résidences** : Création, modification, archivage
- **Gestion des habitants** : Suivi des résidents par résidence
- **Gestion des activités** : Planification, suivi et bilan des activités sociales
- **Statistiques** : Tableaux de bord avec graphiques et export CSV
- **Notifications** : Rappels automatiques par email pour les activités à venir
- **PWA** : Application installable sur mobile avec support hors-ligne

## Stack technique

- **Ruby 3.3** / **Rails 8.1**
- **PostgreSQL**
- **Tailwind CSS 4**
- **Hotwire** (Turbo + Stimulus)
- **Chart.js** pour les graphiques
- **RSpec** pour les tests

## Installation

### Prérequis

- Ruby 3.3+
- PostgreSQL 14+
- Node.js 20+

### Setup

```bash
# Cloner le repo
git clone git@github.com:damienlethiec/EntrelacsV2.git
cd EntrelacsV2

# Installer les dépendances
bundle install

# Configurer la base de données
bin/rails db:setup

# Lancer le serveur
bin/dev
```

L'application sera accessible sur http://localhost:3000

### Comptes de test (après seeds)

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Admin | admin@entrelacs.fr | password123 |
| Tisseur | marie@entrelacs.fr | password123 |

## Tests

```bash
# Lancer tous les tests
bundle exec rspec

# Avec couverture
COVERAGE=true bundle exec rspec

# Linter
bundle exec standardrb
```

## Déploiement

L'application est déployée sur **Scalingo**.

```bash
# Déployer
git push scalingo main

# Console production
scalingo run rails console -a entrelacs-app

# Logs
scalingo logs -a entrelacs-app
```

### Variables d'environnement requises

- `DATABASE_URL` : URL PostgreSQL
- `RAILS_MASTER_KEY` : Clé de déchiffrement des credentials
- `BREVO_SMTP_USERNAME` : Identifiant SMTP Brevo
- `BREVO_SMTP_PASSWORD` : Mot de passe SMTP Brevo

## Structure du projet

```
app/
├── controllers/     # Contrôleurs Rails
├── models/          # Modèles ActiveRecord
├── views/           # Templates ERB
├── javascript/      # Stimulus controllers
└── policies/        # Politiques Pundit

config/
└── locales/         # Traductions FR

spec/                # Tests RSpec
```

## Rôles utilisateurs

| Rôle | Permissions |
|------|-------------|
| **Admin** | Accès total, statistiques globales, gestion des utilisateurs |
| **Tisseur** | Gestion de sa résidence, ses habitants et ses activités |

## Licence

Projet privé - Les Tisseurs de Liens
