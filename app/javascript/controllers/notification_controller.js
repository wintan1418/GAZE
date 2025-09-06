import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss after 5 seconds
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  close() {
    this.dismiss()
  }

  dismiss() {
    // Add fade out animation
    this.element.classList.add('opacity-0', 'transform', 'translate-x-full')
    
    // Remove element after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}