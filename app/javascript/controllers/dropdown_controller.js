import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.hideHandler = this.hide.bind(this)
    this.keydownHandler = this.handleKeydown.bind(this)
    document.addEventListener("click", this.hideHandler)
    document.addEventListener("keydown", this.keydownHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.hideHandler)
    document.removeEventListener("keydown", this.keydownHandler)
  }

  toggle(event) {
    event.stopPropagation()
    const isHidden = this.menuTarget.classList.toggle("hidden")

    if (!isHidden) {
      this.menuTarget.setAttribute("aria-expanded", "true")
      this.focusFirstItem()
    } else {
      this.menuTarget.setAttribute("aria-expanded", "false")
    }
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.menuTarget.setAttribute("aria-expanded", "false")
  }

  handleKeydown(event) {
    if (!this.isOpen()) return

    switch (event.key) {
      case "Escape":
        this.close()
        this.element.querySelector("button")?.focus()
        event.preventDefault()
        break
      case "ArrowDown":
        this.focusNextItem()
        event.preventDefault()
        break
      case "ArrowUp":
        this.focusPreviousItem()
        event.preventDefault()
        break
      case "Tab":
        this.close()
        break
    }
  }

  isOpen() {
    return !this.menuTarget.classList.contains("hidden")
  }

  getMenuItems() {
    return Array.from(this.menuTarget.querySelectorAll("a, button"))
  }

  focusFirstItem() {
    const items = this.getMenuItems()
    if (items.length > 0) items[0].focus()
  }

  focusNextItem() {
    const items = this.getMenuItems()
    const currentIndex = items.indexOf(document.activeElement)
    const nextIndex = currentIndex < items.length - 1 ? currentIndex + 1 : 0
    items[nextIndex]?.focus()
  }

  focusPreviousItem() {
    const items = this.getMenuItems()
    const currentIndex = items.indexOf(document.activeElement)
    const prevIndex = currentIndex > 0 ? currentIndex - 1 : items.length - 1
    items[prevIndex]?.focus()
  }
}
