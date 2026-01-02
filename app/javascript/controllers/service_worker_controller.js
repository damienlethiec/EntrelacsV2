import { Controller } from "@hotwired/stimulus"

// This controller registers the service worker
// Add data-controller="service-worker" to the body or a persistent element
export default class extends Controller {
  connect() {
    this.registerServiceWorker()
  }

  async registerServiceWorker() {
    if (!("serviceWorker" in navigator)) return

    try {
      const registration = await navigator.serviceWorker.register("/service-worker.js", {
        scope: "/"
      })

      // Check for updates periodically
      setInterval(() => {
        registration.update()
      }, 60 * 60 * 1000) // Every hour

    } catch (error) {
      console.error("Service worker registration failed:", error)
    }
  }
}
