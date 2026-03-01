# Entrelacs - Instructions de développement

## Description du projet

Entrelacs est une application Rails de gestion d'habitat partagé. Elle permet aux **Tisseurs** (gestionnaires de résidences) de suivre les activités sociales et aux **Administrateurs** de superviser l'ensemble via des statistiques.

## Stack technique

- **Ruby 4.0** / **Rails 8.1**
- **PostgreSQL 17** (container Docker en prod)
- **Tailwind CSS 4** avec thème custom
- **Hotwire** (Turbo + Stimulus)
- **RSpec** pour les tests
- **Kamal 2** pour le déploiement
- **Solid Queue** pour les jobs (intégré à Puma via `SOLID_QUEUE_IN_PUMA`)

## Conventions

### Rôles utilisateurs
- `admin` : Superviseur global, accès aux stats de toutes les résidences
- `weaver` (tisseur) : Gestionnaire d'une résidence, gère habitants et activités

### Modèles principaux
- `User` : Utilisateurs (admin ou tisseur)
- `Residence` : Résidences avec soft delete
- `Resident` : Habitants d'une résidence (Phase 2)
- `Activity` : Activités sociales (Phase 3)

### Couleurs du thème
```css
--color-tisseurs-teal: #0e7c7c      /* Primaire */
--color-tisseurs-teal-dark: #065e5e
--color-tisseurs-coral: #f26851     /* Danger/Accent */
--color-tisseurs-cream: #fdf6eb     /* Background */
```

### Locale
L'application est entièrement en **français**. Toujours utiliser les clés i18n.

## Structure des fichiers

```
app/
├── controllers/
├── models/
├── views/
│   ├── devise/          # Vues auth stylisées
│   ├── layouts/
│   └── shared/          # Partials (_navbar, _flash)
├── javascript/
│   └── controllers/     # Stimulus controllers
└── assets/
    └── tailwind/        # CSS custom

config/
└── locales/
    ├── fr.yml           # Traductions générales
    └── devise.fr.yml    # Traductions Devise

spec/
├── factories/
├── models/
└── requests/
```

## Commandes utiles

```bash
# Serveur de dev
bin/dev

# Tests
bundle exec rspec

# Console Rails
bin/rails console

# Migrations
bin/rails db:migrate
```

## Déploiement (Kamal)

### Infrastructure

| Composant | Détail |
|-----------|--------|
| Serveur | Scaleway DEV1-S, Paris (PAR1), 2 vCPUs, 2 Go RAM + 2 Go swap, 20 Go SSD |
| IP | 212.47.237.151 |
| OS | Ubuntu 24.04 LTS |
| Registry | ghcr.io/damienlethiec/entrelacs |
| PostgreSQL | Container Docker (accessory Kamal), postgres:17-alpine |
| SSL | Désactivé (mode IP seule) |
| Emails | Désactivés en prod (`SMTP_ENABLED` non défini) |
| SSH | Clé dédiée `~/.ssh/kamal_entrelacs` |

### Commandes Kamal

```bash
kamal deploy          # Déployer une nouvelle version
kamal setup           # Premier déploiement (installe Docker, proxy, DB, app)
kamal console         # Console Rails en prod
kamal logs            # Logs en direct
kamal shell           # Shell bash sur le conteneur
kamal dbc             # Console PostgreSQL
kamal app exec "CMD"  # Exécuter une commande (ex: bin/rails db:seed)
```

### Variables d'environnement requises (locales)

```bash
export KAMAL_REGISTRY_PASSWORD=ghp_xxx  # GitHub PAT (scope write:packages)
export POSTGRES_PASSWORD=xxx            # Mot de passe PostgreSQL prod
```

Ces variables doivent être définies dans le shell avant tout `kamal deploy`.
`RAILS_MASTER_KEY` est lu automatiquement depuis `config/master.key`.

### Fichiers clés

| Fichier | Rôle |
|---------|------|
| `config/deploy.yml` | Configuration Kamal (serveurs, registry, accessories, env) |
| `.kamal/secrets` | Résolution des secrets (lit master.key + env vars) |
| `config/postgres/init.sql` | Crée les bases cache/queue/cable au premier boot PostgreSQL |
| `config/recurring.yml` | Jobs Solid Queue récurrents (notifications quotidiennes à 8h) |

### Activer le SSL (quand un domaine sera configuré)

1. Configurer le DNS A → 212.47.237.151
2. Dans `config/deploy.yml`, décommenter la section `proxy:` et renseigner le host
3. Ajouter dans `env.clear` : `APP_SSL: true`
4. `kamal deploy`

### Activer les emails

Ajouter dans `env.clear` de `config/deploy.yml` :
```yaml
SMTP_ENABLED: true
```
Puis `kamal deploy`. Les credentials Brevo sont dans `config/credentials.yml.enc`.

### TODO ops

- [ ] Configurer les backups PostgreSQL (cron `pg_dump` quotidien sur le serveur)
- [ ] Migrer les données depuis Scalingo (export Scalingo → import dans PostgreSQL Kamal)
- [ ] Configurer un domaine + SSL
- [ ] Basculer le DNS de Scalingo vers Scaleway
- [ ] Supprimer l'app Scalingo

## Phases de développement

1. **Phase 1** : Setup (Rails, Devise, Pundit, Layout) ✅
2. **Phase 2** : Gestion des Résidences ✅
3. **Phase 3** : Gestion des Activités
4. **Phase 4** : Statistiques
5. **Phase 5** : Gestion des Habitants
6. **Phase 6** : Gestion des Users
7. **Phase 7** : Notifications email
8. **Phase 8** : Tests E2E
9. **Phase 9** : Déploiement ✅ (Kamal sur Scaleway)

## Règles de développement

1. **TDD** : Écrire les tests avant l'implémentation
2. **The Rails Way** : Convention over configuration
3. **i18n** : Toutes les chaînes en français via les locales
4. **Tailwind** : Utiliser les classes du thème custom
5. **Commits** : Format conventionnel, messages en français

## Comptes de test

```
Admin: admin@entrelacs.fr / password123
Tisseurs: marie@entrelacs.fr, jean@entrelacs.fr, sophie@entrelacs.fr / password123
```

## Fichiers de référence

- `requirements.md` : Spécifications complètes
- `design-components.md` : Composants Tailwind UI adaptés
