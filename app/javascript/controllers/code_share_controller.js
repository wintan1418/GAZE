import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["codeBlock", "title", "language"]
  
  // Copy code as formatted image
  async copyAsImage(event) {
    event.preventDefault()
    
    try {
      // Check if target exists
      if (!this.hasCodeBlockTarget) {
        console.error('CodeBlock target not found')
        this.showError(event.currentTarget, 'Code block not found')
        return
      }
      
      // Show loading state
      const button = event.currentTarget
      const originalText = button.innerHTML
      
      button.innerHTML = `
        <svg class="w-4 h-4 mr-2 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
        </svg>
        Creating image...
      `
      
      // Create beautiful code snippet image
      const canvas = await this.createBeautifulCodeImage()
      
      // Convert to blob and copy to clipboard
      canvas.toBlob(async (blob) => {
        try {
          if (navigator.clipboard && ClipboardItem) {
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
          } else {
            // Fallback to download if clipboard API not available
            this.fallbackDownload(canvas, button, originalText)
          }
        } catch (err) {
          console.error('Failed to copy image:', err)
          this.fallbackDownload(canvas, button, originalText)
        }
      }, 'image/png')
      
    } catch (error) {
      console.error('Error generating image:', error)
      const button = event.currentTarget
      this.showError(button, 'Failed to generate image')
    }
  }
  
  // Create beautiful Carbon.now.sh style code image using Canvas API
  async createBeautifulCodeImage() {
    // Get code content
    const title = this.hasTitleTarget ? this.titleTarget.textContent : 'Code Snippet'
    const language = this.hasLanguageTarget ? this.languageTarget.textContent : 'code'
    const codeText = this.getCleanCode()
    
    // Create canvas
    const canvas = document.createElement('canvas')
    const ctx = canvas.getContext('2d')
    
    // Set canvas size (high resolution for crisp image)
    const scale = 2
    const width = 800
    const height = Math.max(400, codeText.split('\n').length * 20 + 200)
    
    canvas.width = width * scale
    canvas.height = height * scale
    ctx.scale(scale, scale)
    
    // Create gradient background
    const gradient = ctx.createLinearGradient(0, 0, width, height)
    gradient.addColorStop(0, '#667eea')
    gradient.addColorStop(1, '#764ba2')
    ctx.fillStyle = gradient
    ctx.fillRect(0, 0, width, height)
    
    // Window frame
    const windowX = 60
    const windowY = 60
    const windowWidth = width - 120
    const windowHeight = height - 120
    
    // Window background
    ctx.fillStyle = '#1e1e1e'
    this.roundRect(ctx, windowX, windowY, windowWidth, windowHeight, 12)
    ctx.fill()
    
    // Window header
    ctx.fillStyle = '#252526'
    this.roundRect(ctx, windowX, windowY, windowWidth, 50, 12)
    ctx.fill()
    
    // Header bottom rectangle to square off bottom
    ctx.fillRect(windowX, windowY + 38, windowWidth, 12)
    
    // Window controls
    const controlY = windowY + 18
    const controlColors = ['#ff5f56', '#ffbd2e', '#27ca3f']
    controlColors.forEach((color, i) => {
      ctx.fillStyle = color
      ctx.beginPath()
      ctx.arc(windowX + 25 + (i * 20), controlY, 6, 0, 2 * Math.PI)
      ctx.fill()
    })
    
    // Filename
    ctx.fillStyle = '#d4d4d4'
    ctx.font = '14px ui-monospace, monospace'
    const filename = `${title.toLowerCase().replace(/\s+/g, '-')}.${language.toLowerCase()}`
    ctx.fillText(filename, windowX + 90, controlY + 4)
    
    // Code content with syntax highlighting
    ctx.font = '14px ui-monospace, monospace'
    const lines = codeText.split('\n')
    const lineHeight = 20
    const codeStartY = windowY + 70
    
    lines.forEach((line, i) => {
      this.drawSyntaxHighlightedLine(ctx, line, windowX + 24, codeStartY + (i * lineHeight), language)
    })
    
    // Watermark
    ctx.fillStyle = 'rgba(255, 255, 255, 0.5)'
    ctx.font = '10px ui-monospace, monospace'
    ctx.fillText('gaze.dev', width - 80, height - 20)
    
    return canvas
  }
  
  // Draw syntax highlighted line
  drawSyntaxHighlightedLine(ctx, line, x, y, language) {
    const tokens = this.tokenizeLine(line, language)
    let currentX = x
    
    tokens.forEach(token => {
      ctx.fillStyle = this.getTokenColor(token.type)
      ctx.fillText(token.text, currentX, y)
      currentX += ctx.measureText(token.text).width
    })
  }
  
  // Simple tokenizer for basic syntax highlighting
  tokenizeLine(line, language) {
    const tokens = []
    let currentToken = ''
    let currentType = 'text'
    
    // Keywords by language
    const keywords = {
      javascript: ['const', 'let', 'var', 'function', 'return', 'if', 'else', 'for', 'while', 'class', 'import', 'export', 'from', 'async', 'await', 'true', 'false', 'null', 'undefined'],
      python: ['def', 'class', 'import', 'from', 'return', 'if', 'else', 'elif', 'for', 'while', 'try', 'except', 'with', 'as', 'True', 'False', 'None'],
      ruby: ['def', 'class', 'module', 'if', 'else', 'elsif', 'end', 'do', 'while', 'for', 'case', 'when', 'require', 'include', 'true', 'false', 'nil'],
      java: ['public', 'private', 'static', 'void', 'class', 'interface', 'extends', 'implements', 'if', 'else', 'for', 'while', 'try', 'catch', 'import', 'package', 'true', 'false', 'null'],
      css: ['color', 'background', 'margin', 'padding', 'border', 'width', 'height', 'display', 'position', 'flex', 'grid'],
      html: ['div', 'span', 'p', 'h1', 'h2', 'h3', 'body', 'head', 'title', 'script', 'style', 'link']
    }
    
    const langKeywords = keywords[language] || []
    
    // Simple regex-based tokenization
    const patterns = [
      { regex: /"[^"]*"/g, type: 'string' },
      { regex: /'[^']*'/g, type: 'string' },
      { regex: /`[^`]*`/g, type: 'string' },
      { regex: /\/\/.*$/g, type: 'comment' },
      { regex: /\/\*[\s\S]*?\*\//g, type: 'comment' },
      { regex: /#.*$/g, type: 'comment' },
      { regex: /\b\d+\.?\d*\b/g, type: 'number' },
      { regex: /[{}[\]()]/g, type: 'bracket' },
      { regex: /[+\-*/<>=!&|]/g, type: 'operator' }
    ]
    
    let remaining = line
    let pos = 0
    
    while (remaining.length > 0) {
      let matched = false
      
      // Try to match patterns
      for (const pattern of patterns) {
        pattern.regex.lastIndex = 0
        const match = pattern.regex.exec(remaining)
        if (match && match.index === 0) {
          if (pos > 0) {
            // Add any preceding text
            const precedingText = remaining.substring(0, match.index)
            if (precedingText.trim()) {
              tokens.push(...this.tokenizeWords(precedingText, langKeywords))
            }
          }
          tokens.push({ text: match[0], type: pattern.type })
          remaining = remaining.substring(match[0].length)
          pos += match[0].length
          matched = true
          break
        }
      }
      
      if (!matched) {
        // No pattern matched, take one character
        const char = remaining[0]
        currentToken += char
        remaining = remaining.substring(1)
        pos++
        
        // If we hit whitespace or end, process the current token
        if (/\s/.test(char) || remaining.length === 0) {
          if (currentToken.trim()) {
            tokens.push(...this.tokenizeWords(currentToken, langKeywords))
          }
          currentToken = ''
        }
      }
    }
    
    return tokens
  }
  
  // Tokenize words to identify keywords
  tokenizeWords(text, keywords) {
    const tokens = []
    const words = text.split(/(\s+)/)
    
    words.forEach(word => {
      if (word.trim() === '') {
        tokens.push({ text: word, type: 'text' })
      } else if (keywords.includes(word.trim())) {
        tokens.push({ text: word, type: 'keyword' })
      } else {
        tokens.push({ text: word, type: 'text' })
      }
    })
    
    return tokens
  }
  
  // Get color for token type (VS Code dark theme colors)
  getTokenColor(type) {
    const colors = {
      keyword: '#569cd6',     // Blue
      string: '#ce9178',      // Orange
      comment: '#6a9955',     // Green
      number: '#b5cea8',      // Light green
      bracket: '#ffd700',     // Gold
      operator: '#d4d4d4',    // Light gray
      text: '#d4d4d4'         // Default light gray
    }
    return colors[type] || colors.text
  }
  
  // Helper method to draw rounded rectangles
  roundRect(ctx, x, y, width, height, radius) {
    ctx.beginPath()
    ctx.moveTo(x + radius, y)
    ctx.lineTo(x + width - radius, y)
    ctx.quadraticCurveTo(x + width, y, x + width, y + radius)
    ctx.lineTo(x + width, y + height - radius)
    ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height)
    ctx.lineTo(x + radius, y + height)
    ctx.quadraticCurveTo(x, y + height, x, y + height - radius)
    ctx.lineTo(x, y + radius)
    ctx.quadraticCurveTo(x, y, x + radius, y)
    ctx.closePath()
  }
  
  // Copy as formatted code block for social media
  copyForSocial(event) {
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
  copyAsMarkdown(event) {
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