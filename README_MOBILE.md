# Entrelacs — App mobile (Hotwire Native)

Coque Android qui affiche Entrelacs via Hotwire Native avec native feel (bottom nav par rôle, splash/icône brandés, bridge haptique). Prod sur `https://entrelacs.dlet.fr`, distribution via Play Console Internal Testing.

## État

- **Android** : app fonctionnelle, AAB release signable via `./gradlew bundleRelease`, en attente de la vérification d'identité Google pour publier sur Internal Testing.
- **iOS** : différé. Nécessite Xcode 16+ compatible macOS 15, ou une mise à jour macOS vers 26+.
- **Prod Rails** : `https://entrelacs.dlet.fr` (HTTPS via Kamal proxy + Let's Encrypt).

## Architecture mobile

- **Serveur Rails** reste le cerveau :
  - `MobileController` (`/mobile/config`) sert la path configuration Hotwire + tabs adaptés au rôle du user (admin / weaver).
  - Helper `native_app?` détecte le contexte Hotwire Native via un cookie `hotwire_native` (primaire) ou le User-Agent (fallback).
  - Layout masque le web navbar quand `native_app?`, réduit les paddings, scope la CSS safe-area au non-natif.
  - `AccountController` (`/account`) rend la page de profil avec bouton déconnexion.
- **App Android** (`android/Entrelacs/`) est une coque qui obéit à la config :
  - `MainActivity` extends `HotwireActivity`, dépose le cookie de signalement, charge `/mobile/config` en remote pour la path configuration et les tabs, wire la `BottomNavigationView`.
  - Bridge pattern : `HapticComponent.kt` reçoit `vibrate` depuis le Stimulus `haptic_controller.js` et déclenche une vibration native.

## Prérequis

- [Tailscale](https://tailscale.com) avec HTTPS Certificates activé
- Android Studio + émulateur API 28+
- Compte Apple Developer + Google Play Console (pour la distribution plus tard)

## Workflow dev

Trois terminaux :

```bash
# 1. Rails
bin/dev

# 2. Tunnel Tailscale Funnel vers Rails local
tailscale funnel --bg 3000
tailscale funnel status   # récupère l'URL https://<device>.<tailnet>.ts.net

# 3. Android : ouvrir android/Entrelacs dans Android Studio → Run
```

## Changer l'URL du tunnel

Si l'URL Tailscale change (rare), éditer :

```
android/Entrelacs/app/src/main/java/fr/entrelacs/app/util/Config.kt
```

et mettre à jour `BASE_URL`. Rebuild.

## Identifiants

- **applicationId** : `fr.entrelacs.app` (figé pour compatibilité Play Store)
- **Compte test Rails** : `marie@entrelacs.fr` / `password123` (après `bin/rails db:seed`)
- **Domaine prod** : `entrelacs.dlet.fr` (sous-domaine de dlet.fr, cert Let's Encrypt)

## Release Play Store Internal Testing

### Prérequis (une seule fois)

- Compte Google Play Console actif (vérification d'identité validée par Google)
- Keystore upload : `android/Entrelacs/app/entrelacs-upload.jks` (gitignored)
- `android/Entrelacs/keystore.properties` avec les mots de passe (gitignored)
- Backup du keystore + mot de passe dans 1Password

### Procédure à chaque release

```bash
# 1. Incrémenter versionCode dans android/Entrelacs/app/build.gradle.kts
# 2. Build l'AAB release signée
cd android/Entrelacs
./gradlew bundleRelease
# 3. L'AAB est à : app/build/outputs/bundle/release/app-release.aab
```

Puis sur Play Console :
1. `Testing > Internal testing > Create new release`
2. Upload `app-release.aab`
3. Remplir les release notes
4. `Review release` → `Start rollout`

Les testeurs déjà opt-in reçoivent la mise à jour automatiquement via Play Store.

### Si keystore perdu

Contacter Google Play Console support, demander un reset de la clé d'upload. Ils fournissent une nouvelle clé, régénérer `entrelacs-upload.jks` localement, re-uploader.

## Secrets locaux requis

- **`config/master.key`** : clé Rails pour déchiffrer credentials.yml.enc. Backup dans 1Password.
- **`.envrc`** (auto-chargé par direnv) : `KAMAL_REGISTRY_PASSWORD` (GitHub PAT) + `POSTGRES_PASSWORD`. Backup dans 1Password.
- **`android/Entrelacs/keystore.properties`** + **`.jks`** : voir section release.

## Known issues

- **Rafraîchissement des tabs après login** : au premier lancement de l'app (ou après logout dans la WebView), les tabs n'apparaissent qu'après avoir kill et rouvert l'app. Raison : l'app fetch `/mobile/config` au démarrage (pas de session → pas de tabs), et n'écoute pas les événements de navigation Hotwire. Workaround : kill + reopen. Fix propre : implémenter un listener sur `NavigatorDelegate.onVisitCompleted` (API Hotwire Native Android 1.2.x à confirmer).
- **Déconnexion par la bottom nav → tabs résiduels** : après tap sur Déconnexion, la bottom nav reste visible sur la page login tant que l'app n'est pas ramenée au foreground (ce qui déclenche `onResume` et le refresh). Fonctionnellement inoffensif (tap sur un tab redirigerait vers login de toute façon).
- **Émulateur sans haptic** : l'émulateur n'a pas de moteur de vibration. Tester sur device physique ou vérifier le log `HapticComponent` dans Logcat pour confirmer que le bridge reçoit les messages.

## Suite prévue

1. **Publier sur Play Console Internal Testing** : dès validation identité Google
2. **iOS** : après update macOS ou install Xcode 16
3. **Closed Testing** puis Production : une fois l'Internal stabilisée
4. **Flash messages → toasts natifs** : nouveau bridge component
5. **Listener de navigation** pour fix propre du refresh tabs post-login
6. **Adapter certaines vues au mobile** : formulaires, page activité
