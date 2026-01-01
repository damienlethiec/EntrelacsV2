import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]
  static values = { duration: { type: Number, default: 5000 } }

  connect() {
    this.autoHide()
  }

  autoHide() {
    setTimeout(() => {
      this.dismiss()
    }, this.durationValue)
  }

  dismiss() {
    this.messageTargets.forEach(message => {
      message.classList.add("opacity-0")
      setTimeout(() => {
        message.remove()
      }, 300)
    })
  }
}
