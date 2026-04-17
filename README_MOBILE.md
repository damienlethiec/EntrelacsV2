# Entrelacs — App mobile (Hotwire Native)

Coque Android minimale qui affiche Entrelacs via Hotwire Native. Hors scope : push, bridges, distribution sur stores.

Design complet : `docs/superpowers/specs/2026-04-17-hotwire-native-hello-world-design.md`

## État

- **Android** : fonctionnel, tourne sur émulateur, charge l'app Rails via tunnel Tailscale.
- **iOS** : différé. Le scaffold iOS nécessite Xcode 16+ compatible avec macOS 15, ou une mise à jour vers macOS 26+.

## Prérequis

- [Tailscale](https://tailscale.com) (compte gratuit) avec **HTTPS Certificates** activés sur [admin.tailscale.com/dns](https://login.tailscale.com/admin/dns)
- [Android Studio](https://developer.android.com/studio)
- Émulateur Android API 28+ (Pixel 7 recommandé)

## Workflow dev

Trois terminaux :

```bash
# 1. Rails
bin/dev

# 2. Tunnel Tailscale
tailscale funnel --bg 3000
tailscale funnel status   # récupère https://<device>.<tailnet>.ts.net

# 3. Android : ouvrir android/Entrelacs dans Android Studio, Run
```

Si le tunnel ou Rails tombe : l'app affichera "Error loading page". Relancer les deux et pull-to-refresh dans l'app.

## Changer l'URL du tunnel

Quand l'URL Tailscale change (rare, mais possible si tu renommes ton device ou ton tailnet), éditer :

```
android/Entrelacs/app/src/main/kotlin/fr/entrelacs/app/util/Config.kt
```

et mettre à jour la constante `BASE_URL`. Puis Rebuild.

## Identifiants

- **applicationId** : `fr.entrelacs.app` (figé pour compatibilité future avec Google Play)
- **Compte test Rails** : `marie@entrelacs.fr` / `password123` (après `bin/rails db:seed`)

## Suite prévue

1. **iOS** : après mise à jour macOS ou install de Xcode 16, reprendre le scaffold iOS (spec section "Architecture")
2. **Adapter les vues Rails au mobile** : `viewport-fit=cover` + `env(safe-area-inset-*)` pour un meilleur rendu
3. **Path configuration** : corriger la navigation (pour que le back-button ne remonte pas au login quand l'user est connecté)
4. **Bridge components** : push notifications, scan QR
5. **Distribution privée** : TestFlight (iOS) + Play Closed Testing (Android)
