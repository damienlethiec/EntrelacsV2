# Entrelacs - Instructions de développement

## Description du projet

Entrelacs est une application Rails de gestion d'habitat partagé. Elle permet aux **Tisseurs** (gestionnaires de résidences) de suivre les activités sociales et aux **Administrateurs** de superviser l'ensemble via des statistiques.

## Stack technique

- **Ruby 4.0** / **Rails 8.1**
- **PostgreSQL 18**
- **Tailwind CSS 4** avec thème custom
- **Hotwire** (Turbo + Stimulus)
- **RSpec** pour les tests

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

## Phases de développement

1. **Phase 1** : Setup (Rails, Devise, Pundit, Layout) ✅
2. **Phase 2** : Gestion des Résidences ✅
3. **Phase 3** : Gestion des Activités
4. **Phase 4** : Statistiques
5. **Phase 5** : Gestion des Habitants
6. **Phase 6** : Gestion des Users
7. **Phase 7** : Notifications email
8. **Phase 8** : Tests E2E
9. **Phase 9** : Déploiement

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
