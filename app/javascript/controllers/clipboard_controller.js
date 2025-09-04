import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }
  
  copy(event) {
    const text = this.element.dataset.clipboardText || this.textValue
    
    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(() => {
        this.showFeedback(event.target)
      }).catch(() => {
        this.fallbackCopy(text, event.target)
      })
    } else {
      this.fallbackCopy(text, event.target)
    }
  }
  
  fallbackCopy(text, button) {
    const textarea = document.createElement('textarea')
    textarea.value = text
    textarea.style.position = 'fixed'
    textarea.style.opacity = '0'
    document.body.appendChild(textarea)
    textarea.select()
    
    try {
      document.execCommand('copy')
      this.showFeedback(button)
    } catch (err) {
      console.error('Could not copy text: ', err)
    }
    
    document.body.removeChild(textarea)
  }
  
  showFeedback(button) {
    const originalText = button.innerHTML
    
    button.innerHTML = `
      <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      Copied!
    `
    
    button.classList.add('text-green-600', 'dark:text-green-400')
    
    setTimeout(() => {
      button.innerHTML = originalText
      button.classList.remove('text-green-600', 'dark:text-green-400')
    }, 2000)
  }
}