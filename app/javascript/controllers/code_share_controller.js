import { Controller } from "@hotwired/stimulus"
import html2canvas from "html2canvas"

export default class extends Controller {
  static targets = ["codeBlock", "title", "language"]
  
  // Copy code as formatted image
  async copyAsImage() {
    try {
      // Show loading state
      const button = event.currentTarget
      const originalText = button.innerHTML
      button.innerHTML = `
        <svg class="w-4 h-4 mr-2 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
        </svg>
        Creating image...
      `
      
      // Create a canvas from the code block
      const canvas = await html2canvas(this.codeBlockTarget, {
        backgroundColor: '#1e1e1e',
        scale: 2, // Higher quality
        useCORS: true,
        allowTaint: true,
        width: this.codeBlockTarget.scrollWidth,
        height: this.codeBlockTarget.scrollHeight,
        onclone: (clonedDoc) => {
          // Ensure fonts are loaded in the clone
          const clonedElement = clonedDoc.querySelector('.syntax-highlighted')
          if (clonedElement) {
            clonedElement.style.fontFamily = "'JetBrains Mono', 'Fira Code', 'Monaco', 'Consolas', monospace"
          }
        }
      })
      
      // Convert to blob and copy to clipboard
      canvas.toBlob(async (blob) => {
        try {
          await navigator.clipboard.write([
            new ClipboardItem({ 'image/png': blob })
          ])
          
          // Success feedback
          button.innerHTML = `
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
            Image copied!
          `
          button.classList.add('text-green-600', 'dark:text-green-400')
          
          setTimeout(() => {
            button.innerHTML = originalText
            button.classList.remove('text-green-600', 'dark:text-green-400')
          }, 2000)
        } catch (err) {
          console.error('Failed to copy image:', err)
          this.fallbackDownload(canvas, button, originalText)
        }
      }, 'image/png')
      
    } catch (error) {
      console.error('Error generating image:', error)
      this.showError(event.currentTarget, 'Failed to generate image')
    }
  }
  
  // Copy as formatted code block for social media
  copyForSocial() {
    const title = this.hasTitleTarget ? this.titleTarget.textContent : 'Code Snippet'
    const language = this.hasLanguageTarget ? this.languageTarget.textContent : ''
    const code = this.getCleanCode()
    
    // Format for social media sharing
    const socialFormat = `💻 ${title}\n\n\`\`\`${language.toLowerCase()}\n${code}\n\`\`\`\n\n#coding #${language.toLowerCase()} #gaze`
    
    // Copy to clipboard
    if (navigator.clipboard) {
      navigator.clipboard.writeText(socialFormat).then(() => {
        this.showSuccess(event.currentTarget, 'Social post copied!')
      }).catch(() => {
        this.fallbackCopy(socialFormat, event.currentTarget)
      })
    } else {
      this.fallbackCopy(socialFormat, event.currentTarget)
    }
  }
  
  // Copy as markdown code block
  copyAsMarkdown() {
    const title = this.hasTitleTarget ? this.titleTarget.textContent : 'Code Snippet'
    const language = this.hasLanguageTarget ? this.languageTarget.textContent : ''
    const code = this.getCleanCode()
    
    // Format as markdown
    const markdownFormat = `## ${title}\n\n\`\`\`${language.toLowerCase()}\n${code}\n\`\`\`\n\n*Shared from [GAZE](${window.location.origin})*`
    
    if (navigator.clipboard) {
      navigator.clipboard.writeText(markdownFormat).then(() => {
        this.showSuccess(event.currentTarget, 'Markdown copied!')
      }).catch(() => {
        this.fallbackCopy(markdownFormat, event.currentTarget)
      })
    } else {
      this.fallbackCopy(markdownFormat, event.currentTarget)
    }
  }
  
  // Download image as fallback
  fallbackDownload(canvas, button, originalText) {
    const link = document.createElement('a')
    link.download = `${this.getFileName()}.png`
    link.href = canvas.toDataURL()
    link.click()
    
    button.innerHTML = `
      <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-4-4m4 4l4-4m-4 4V3"></path>
      </svg>
      Downloaded!
    `
    button.classList.add('text-blue-600', 'dark:text-blue-400')
    
    setTimeout(() => {
      button.innerHTML = originalText
      button.classList.remove('text-blue-600', 'dark:text-blue-400')
    }, 2000)
  }
  
  // Get clean code without line numbers
  getCleanCode() {
    // Try to get code from the data attribute first
    const codeText = this.codeBlockTarget.dataset.code
    if (codeText) return codeText
    
    // Fallback: extract from DOM, removing line numbers
    const codeElements = this.codeBlockTarget.querySelectorAll('.code pre')
    if (codeElements.length > 0) {
      return codeElements[0].textContent
    }
    
    return this.codeBlockTarget.textContent
  }
  
  // Generate filename
  getFileName() {
    const title = this.hasTitleTarget ? this.titleTarget.textContent : 'snippet'
    const language = this.hasLanguageTarget ? this.languageTarget.textContent : 'code'
    return `${title.toLowerCase().replace(/\s+/g, '-')}-${language.toLowerCase()}`
  }
  
  // Show success feedback
  showSuccess(button, message) {
    const originalText = button.innerHTML
    button.innerHTML = `
      <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
      </svg>
      ${message}
    `
    button.classList.add('text-green-600', 'dark:text-green-400')
    
    setTimeout(() => {
      button.innerHTML = originalText
      button.classList.remove('text-green-600', 'dark:text-green-400')
    }, 2000)
  }
  
  // Show error feedback
  showError(button, message) {
    const originalText = button.innerHTML
    button.innerHTML = `
      <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      </svg>
      ${message}
    `
    button.classList.add('text-red-600', 'dark:text-red-400')
    
    setTimeout(() => {
      button.innerHTML = originalText
      button.classList.remove('text-red-600', 'dark:text-red-400')
    }, 3000)
  }
  
  // Fallback text copy
  fallbackCopy(text, button) {
    const textarea = document.createElement('textarea')
    textarea.value = text
    textarea.style.position = 'fixed'
    textarea.style.opacity = '0'
    document.body.appendChild(textarea)
    textarea.select()
    
    try {
      document.execCommand('copy')
      this.showSuccess(button, 'Copied!')
    } catch (err) {
      this.showError(button, 'Copy failed')
    }
    
    document.body.removeChild(textarea)
  }
}