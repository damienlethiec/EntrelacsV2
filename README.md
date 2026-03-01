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

- **Ruby 4.0** / **Rails 8.1**
- **PostgreSQL 17**
- **Tailwind CSS 4**
- **Hotwire** (Turbo + Stimulus)
- **Chart.js** pour les graphiques
- **RSpec** pour les tests
- **Kamal 2** pour le déploiement

## Installation

### Prérequis

- Ruby 4.0+
- PostgreSQL 17+
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

L'application est déployée via **Kamal 2** sur un VPS Scaleway (Paris).

### Prérequis déploiement

- Docker + Docker Buildx installés localement
- [Colima](https://github.com/abiosoft/colima) (macOS) ou Docker Engine (Linux)
- Clé SSH configurée pour le serveur (`~/.ssh/kamal_entrelacs`)
- Variables d'environnement définies dans le shell :

```bash
export KAMAL_REGISTRY_PASSWORD=ghp_xxx  # GitHub PAT (scope write:packages)
export POSTGRES_PASSWORD=xxx            # Mot de passe PostgreSQL prod
```

`RAILS_MASTER_KEY` est lu automatiquement depuis `config/master.key`.

### Commandes

```bash
# Déployer une nouvelle version
kamal deploy

# Console Rails en production
kamal console

# Logs en direct
kamal logs

# Shell sur le conteneur
kamal shell

# Console PostgreSQL
kamal dbc

# Exécuter une commande ponctuelle
kamal app exec "bin/rails db:seed"
```

### Architecture serveur

```
Scaleway DEV1-S (Paris)
├── kamal-proxy          # Reverse proxy, routing HTTP
├── entrelacs-web        # App Rails (Puma + Solid Queue)
└── entrelacs-db         # PostgreSQL 17 (container)
```

- **Registry** : ghcr.io/damienlethiec/entrelacs
- **Build** : distant sur le serveur (via `builder.remote` dans deploy.yml)
- **Jobs** : Solid Queue intégré à Puma (`SOLID_QUEUE_IN_PUMA=true`)
- **Notifications** : job quotidien à 8h (`config/recurring.yml`)

### Configuration

| Fichier | Rôle |
|---------|------|
| `config/deploy.yml` | Serveurs, registry, accessories, variables d'env |
| `.kamal/secrets` | Résolution des secrets (master.key + env vars) |
| `config/postgres/init.sql` | Init des bases cache/queue/cable |
| `config/recurring.yml` | Jobs récurrents Solid Queue |

### SSL et emails

Le SSL et les emails sont désactivés par défaut. Pour les activer, ajouter dans `env.clear` de `config/deploy.yml` :

```yaml
APP_SSL: true       # Active SSL (nécessite un domaine + DNS configuré)
SMTP_ENABLED: true  # Active l'envoi d'emails via Brevo
```

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
