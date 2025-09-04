import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    this.boundClick = this.clickOutside.bind(this)
  }
  
  toggle(event) {
    event.stopPropagation()
    
    if (this.menuTarget.classList.contains("hidden")) {
      this.show()
    } else {
      this.hide()
    }
  }
  
  show() {
    this.menuTarget.classList.remove("hidden")
    document.addEventListener("click", this.boundClick)
  }
  
  hide() {
    this.menuTarget.classList.add("hidden")
    document.removeEventListener("click", this.boundClick)
  }
  
  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hide()
    }
  }
  
  disconnect() {
    document.removeEventListener("click", this.boundClick)
  }
}