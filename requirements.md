# Entrelacs - Application de gestion d'habitat partagé

## Description

Application permettant de gérer une entreprise d'habitat partagé :
- **Tisseurs** : responsables de résidence, gèrent les activités et habitants de leur résidence
- **Admins** : supervisent l'ensemble, accèdent aux statistiques globales

---

## Stack technique

| Technologie | Version | Usage |
|-------------|---------|-------|
| Ruby | 4.0 | Runtime |
| Rails | 8.1 | Framework |
| PostgreSQL | 18 | Base de données |
| Tailwind CSS | 4 | Styling (+ Tailwind UI) |
| Devise | latest | Authentification |
| Devise Invitable | latest | Invitation par email |
| Pundit | latest | Autorisation (vérifiée sur chaque action + vues) |
| RSpec | latest | Tests |
| Letter Opener | latest | Mails en dev |
| Brevo | latest | Mails en prod |
| Solid Queue | latest | Jobs (si besoin) |

---

## Modèle de données

### Residence

| Champ | Type | Contraintes |
|-------|------|-------------|
| name | string | required |
| address | text | required |
| deleted_at | datetime | soft delete |

**Relations** : `has_many :users`, `has_many :residents`, `has_many :activities`

### User

| Champ | Type | Contraintes |
|-------|------|-------------|
| first_name | string | required |
| last_name | string | required |
| email | string | required, unique |
| role | enum | required, values: `admin`, `weaver` |
| residence_id | reference | required si weaver, null si admin |

**Relations** : `belongs_to :residence, optional: true`

### Resident (Habitant)

| Champ | Type | Contraintes |
|-------|------|-------------|
| first_name | string | required |
| last_name | string | required |
| email | string | required |
| residence_id | reference | required |
| deleted_at | datetime | soft delete (conserver pour historique) |

**Relations** : `belongs_to :residence`

### Activity

| Champ | Type | Contraintes |
|-------|------|-------------|
| activity_type | string | required, suggestions des 10 plus fréquents |
| description | text | required |
| review | text | required pour status `completed` |
| participants_count | integer | required pour status `completed` |
| status | enum | required, values: `planned`, `completed`, `canceled` |
| starts_at | datetime | required |
| ends_at | datetime | required |
| notify_residents | boolean | required, default: false |
| email_status | enum | required, values: `none`, `informed`, `reminded` |
| residence_id | reference | required |

**Relations** : `belongs_to :residence`

**Types d'activités suggérés** :
1. Repas partagé
2. Atelier cuisine
3. Jeux de société
4. Café/thé
5. Jardinage
6. Bricolage
7. Sortie culturelle
8. Sport/bien-être
9. Échange de savoirs
10. Réunion habitants

---

## Phases de développement

### Phase 1 : Setup & Authentification

**Setup projet**
- [ ] Rails new avec PostgreSQL, Tailwind, RSpec
- [ ] Configuration Devise
- [ ] Configuration Pundit
- [ ] Layout principal avec navbar
- [ ] Variables CSS custom (voir Design)

**Authentification**
- [ ] Login email/password
- [ ] Logout

**Routes** : `devise_for :users`

---

### Phase 2 : Gestion des Users (Admin only)

| Action | Route | Description |
|--------|-------|-------------|
| index | GET /users | Liste des users (navbar) |
| new | GET /users/new | Formulaire invitation |
| create | POST /users | Envoie invitation (Devise Invitable) |
| edit | GET /users/:id/edit | Modifier user (dont résidence) |
| update | PATCH /users/:id | Sauvegarder modifications |
| destroy | DELETE /users/:id | Supprimer user |

**Autorisation** : Admin uniquement

---

### Phase 3 : Gestion des Résidences

| Action | Route | Accès | Description |
|--------|-------|-------|-------------|
| index | GET /residences | Tous | Liste des résidences (navbar) |
| show | GET /residences/:id | Tous | Détail résidence (redirige vers activities) |
| new | GET /residences/new | Admin | Formulaire création |
| create | POST /residences | Admin | Créer résidence |
| edit | GET /residences/:id/edit | Admin | Formulaire modification |
| update | PATCH /residences/:id | Admin | Modifier (dont assigner tisseur) |
| destroy | DELETE /residences/:id | Admin | Soft delete |

**Action supplémentaire Admin** :
- Réactiver une résidence soft-deleted (bouton dans edit ou action custom)

---

### Phase 4 : Gestion des Habitants (Tisseur de la résidence)

| Action | Route | Description |
|--------|-------|-------------|
| index | GET /residences/:residence_id/residents | Liste habitants |
| new | GET /residences/:residence_id/residents/new | Formulaire création |
| create | POST /residences/:residence_id/residents | Créer habitant |
| edit | GET /residences/:residence_id/residents/:id/edit | Modifier habitant |
| update | PATCH /residences/:residence_id/residents/:id | Sauvegarder |
| destroy | DELETE /residences/:residence_id/residents/:id | Soft delete |

**Autorisation** : Tisseur de cette résidence uniquement

---

### Phase 5 : Activités - CRUD basique

| Action | Route | Accès | Description |
|--------|-------|-------|-------------|
| index | GET /residences/:residence_id/activities | Tous | Activités à venir (paginées 20) |
| index | GET /residences/:residence_id/activities?past=true | Tous | Activités passées (paginées 20) |
| show | GET /residences/:residence_id/activities/:id | Tous | Détail activité |
| new | GET /residences/:residence_id/activities/new | Tisseur | Formulaire création |
| create | POST /residences/:residence_id/activities | Tisseur | Créer activité |
| edit | GET /residences/:residence_id/activities/:id/edit | Tisseur | Modifier activité |
| update | PATCH /residences/:residence_id/activities/:id | Tisseur | Sauvegarder |

**Règles métier** :
- Le tisseur accède directement à l'index des activités de SA résidence (home page)
- Stats en haut de l'index : sur les 30 derniers jours, nombre d'activités **complétées** + nombre total de participants
- Bouton "Voir activités passées" dans l'index
- `review` et `participants_count` non modifiables tant que `starts_at` n'est pas passé

**Annulation** :
- Action cancel (bouton dans show et index si possible)
- Passe le status à `canceled`

---

### Phase 6 : Activités récurrentes

**Dans le formulaire de création** :
- Checkbox "Activité récurrente"
- Si coché, afficher :
  - Date/heure de début (comme d'habitude)
  - Date de fin de récurrence (max 1 an)
  - Fréquence : `weekly` ou `monthly`

**À la validation** :
- Créer toutes les occurrences d'un coup selon les critères
- Chaque occurrence est une Activity indépendante

---

### Phase 7 : Complétion des activités

**En haut de l'index des activités (tisseur uniquement)** :
- Section "Activités à compléter" : liste des activités passées non complétées
- Pour chaque activité : formulaire inline avec :
  - `participants_count` (integer)
  - `review` (text)
  - Bouton "Compléter"
- À validation : status passe à `completed`

---

### Phase 8 : Emails automatiques

**Rake task quotidienne** : `rails activities:send_daily_notifications`

Un seul email par habitant contenant 2 sections :

1. **Nouvelles activités** :
   - Activités avec `notify_residents: true` ET `email_status: none`
   - Après envoi : passer `email_status` à `informed`

2. **Rappels 48h** :
   - Activités avec `notify_residents: true` ET `email_status: informed` ET `starts_at` dans moins de 48h ET non passées
   - Après envoi : passer `email_status` à `reminded`

---

### Phase 9 : Statistiques (Admin only)

**Index stats** : GET /statistics

**Filtres** :
- Plage de dates (date picker)
- Par défaut : 30 derniers jours

**Métriques affichées** (sur activités **complétées** uniquement) :
- Nombre total d'activités complétées
- Nombre total de participants
- Moyenne de participants par activité
- Médiane de participants par activité
- Répartition par type d'activité (nombre + participants)
- Répartition par jour de la semaine (nombre + participants)
- Répartition par moment de la journée : matin (<12h), après-midi (12h-18h), soir (>18h)

**Export CSV** : bouton pour exporter les données de la plage sélectionnée

**Show stats résidence** : GET /statistics/:residence_id
- Mêmes métriques mais filtrées sur une résidence
- Liste des résidences dans l'index pour y accéder

---

## Principes de code

1. **Routes 100% RESTful** : uniquement index, show, new, create, edit, update, destroy
2. **Fat Models, Skinny Controllers** : logique métier dans les models, utiliser des Concerns si besoin
3. **Scopes** : pour les requêtes fréquentes
4. **Conventions Rails** : pas d'options exotiques
5. **Tests** : unitaires sur la logique importante, tests système sur les happy paths
6. **Partials** : pour les composants réutilisables
7. **Pundit** : policy pour chaque controller, vérification dans les vues

---

## Design

### Variables CSS

```css
@theme {
  --color-tisseurs-teal: #0e7c7c;
  --color-tisseurs-teal-dark: #065e5e;
  --color-tisseurs-teal-light: #0a9a9a;
  --color-tisseurs-cream: #fdf6eb;
  --color-tisseurs-cream-dark: #f5ead8;
  --color-tisseurs-coral: #f26851;
  --color-tisseurs-coral-dark: #d9533e;
  --color-tisseurs-coral-light: #ff8573;
  --color-tisseurs-white: #ffffff;
  --color-tisseurs-teal-text: #057c7c;
  --color-tisseurs-gray: #474747;
  --color-tisseurs-gray-light: #6b7280;
  --font-family-harmattan: 'Harmattan', Helvetica, Arial, Lucida, sans-serif;
}
```

### Logo
Fichier : `image.png` (à la racine du projet)

### Composants Tailwind UI
Voir fichier `design-components.md` pour les templates HTML des composants :
- Layout (navbar)
- Formulaires
- Show (description list)
- Stats cards
- Boutons
- Listes

---

## Checklist de développement

- [ ] Phase 1 : Setup & Auth
- [ ] Phase 2 : Users (Admin)
- [ ] Phase 3 : Résidences
- [ ] Phase 4 : Habitants
- [ ] Phase 5 : Activités CRUD
- [ ] Phase 6 : Activités récurrentes
- [ ] Phase 7 : Complétion activités
- [ ] Phase 8 : Emails automatiques
- [ ] Phase 9 : Statistiques
