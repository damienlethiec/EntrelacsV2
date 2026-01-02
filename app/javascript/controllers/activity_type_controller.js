import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radio", "otherField", "otherInput", "hiddenInput"]

  connect() {
    this.updateState()
  }

  select() {
    this.updateState()
  }

  updateState() {
    const selectedRadio = this.radioTargets.find(r => r.checked)
    const isOther = selectedRadio?.value === "other"

    if (isOther) {
      this.otherFieldTarget.classList.remove("hidden")
      this.otherInputTarget.required = true
      this.hiddenInputTarget.value = this.otherInputTarget.value
    } else {
      this.otherFieldTarget.classList.add("hidden")
      this.otherInputTarget.required = false
      if (selectedRadio) {
        this.hiddenInputTarget.value = selectedRadio.value
      }
    }
  }

  updateOther() {
    this.hiddenInputTarget.value = this.otherInputTarget.value
  }
}
