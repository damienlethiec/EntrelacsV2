import { BridgeComponent } from "@hotwired/hotwire-native-bridge"

// Bridge component: déclenche une vibration native quand appelé depuis le web.
// Utilisation dans les vues :
//   data-controller="bridge--haptic"
//   data-action="click->bridge--haptic#vibrate"
//   data-bridge--haptic-style-param="light|medium|heavy"
//
// Sur web hors Hotwire Native, this.send() est un no-op silencieux.
export default class extends BridgeComponent {
  static component = "haptic"

  vibrate(event) {
    const style = event.params.style || "medium"
    this.send("vibrate", { style })
  }
}
