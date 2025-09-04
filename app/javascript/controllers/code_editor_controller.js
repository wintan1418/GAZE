import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "language"]
  
  connect() {
    this.initializeEditor()
  }
  
  initializeEditor() {
    // Add syntax highlighting classes based on language
    this.updateSyntaxHighlighting()
    
    // Enhanced keyboard shortcuts
    this.element.addEventListener('keydown', this.handleKeydown.bind(this))
    this.element.addEventListener('input', this.handleInput.bind(this))
    
    // Language change detection
    if (this.hasLanguageTarget) {
      this.languageTarget.addEventListener('change', this.updateSyntaxHighlighting.bind(this))
    }
    
    // Auto-resize
    this.autoResize()
  }
  
  updateSyntaxHighlighting() {
    const language = this.hasLanguageTarget ? this.languageTarget.value : 'javascript'
    this.element.className = this.element.className.replace(/language-\w+/, '')
    this.element.classList.add(`language-${language}`)
  }
  
  handleKeydown(event) {
    const { key, ctrlKey, metaKey, shiftKey } = event
    const isCmd = ctrlKey || metaKey
    
    // Tab handling
    if (key === 'Tab') {
      event.preventDefault()
      if (shiftKey) {
        this.outdent()
      } else {
        this.indent()
      }
      return
    }
    
    // Auto-closing brackets and quotes
    if (this.shouldAutoClose(key)) {
      event.preventDefault()
      this.autoClose(key)
      return
    }
    
    // Enter key - smart indentation
    if (key === 'Enter') {
      event.preventDefault()
      this.smartNewLine()
      return
    }
    
    // Keyboard shortcuts
    if (isCmd) {
      switch(key) {
        case '/':
          event.preventDefault()
          this.toggleComment()
          break
        case 's':
          event.preventDefault()
          this.element.form.requestSubmit()
          break
      }
    }
  }
  
  handleInput(event) {
    this.autoResize()
    this.updateLineNumbers()
  }
  
  indent() {
    const start = this.element.selectionStart
    const end = this.element.selectionEnd
    const selectedText = this.element.value.substring(start, end)
    
    if (selectedText.includes('\n')) {
      // Multi-line indent
      const lines = selectedText.split('\n')
      const indentedLines = lines.map(line => '  ' + line)
      const newText = indentedLines.join('\n')
      
      this.replaceSelection(newText)
      this.element.selectionStart = start
      this.element.selectionEnd = start + newText.length
    } else {
      // Single line indent
      this.insertText('  ')
    }
  }
  
  outdent() {
    const start = this.element.selectionStart
    const end = this.element.selectionEnd
    const selectedText = this.element.value.substring(start, end)
    
    if (selectedText.includes('\n')) {
      // Multi-line outdent
      const lines = selectedText.split('\n')
      const outdentedLines = lines.map(line => line.replace(/^  /, ''))
      const newText = outdentedLines.join('\n')
      
      this.replaceSelection(newText)
      this.element.selectionStart = start
      this.element.selectionEnd = start + newText.length
    } else {
      // Single line outdent
      const lineStart = this.element.value.lastIndexOf('\n', start - 1) + 1
      const lineText = this.element.value.substring(lineStart, this.element.value.indexOf('\n', start))
      
      if (lineText.startsWith('  ')) {
        this.element.value = this.element.value.substring(0, lineStart) + 
                            lineText.substring(2) + 
                            this.element.value.substring(lineStart + lineText.length)
        this.element.selectionStart = this.element.selectionEnd = Math.max(lineStart, start - 2)
      }
    }
  }
  
  shouldAutoClose(key) {
    const pairs = {
      '(': ')',
      '[': ']',
      '{': '}',
      '"': '"',
      "'": "'",
      '`': '`'
    }
    return pairs.hasOwnProperty(key)
  }
  
  autoClose(key) {
    const pairs = {
      '(': ')',
      '[': ']',
      '{': '}',
      '"': '"',
      "'": "'",
      '`': '`'
    }
    
    const start = this.element.selectionStart
    const end = this.element.selectionEnd
    const selectedText = this.element.value.substring(start, end)
    
    if (selectedText.length > 0) {
      // Wrap selection
      this.replaceSelection(key + selectedText + pairs[key])
      this.element.selectionStart = start + 1
      this.element.selectionEnd = end + 1
    } else {
      // Insert pair
      this.insertText(key + pairs[key])
      this.element.selectionStart = this.element.selectionEnd = start + 1
    }
  }
  
  smartNewLine() {
    const start = this.element.selectionStart
    const currentLine = this.getCurrentLine()
    const indent = this.getIndentation(currentLine)
    const needsExtraIndent = /[\{\[\(]\s*$/.test(currentLine.trim())
    
    let newText = '\n' + indent
    if (needsExtraIndent) {
      newText += '  '
    }
    
    this.insertText(newText)
  }
  
  toggleComment() {
    const language = this.hasLanguageTarget ? this.languageTarget.value : 'javascript'
    const commentMap = {
      'javascript': '//',
      'typescript': '//',
      'python': '#',
      'ruby': '#',
      'java': '//',
      'c': '//',
      'cpp': '//',
      'csharp': '//',
      'php': '//',
      'go': '//',
      'rust': '//',
      'swift': '//',
      'kotlin': '//',
      'css': '/*',
      'html': '<!--',
      'sql': '--',
      'shell': '#',
      'yaml': '#'
    }
    
    const commentSymbol = commentMap[language] || '//'
    const start = this.element.selectionStart
    const end = this.element.selectionEnd
    const selectedText = this.element.value.substring(start, end)
    
    if (selectedText.includes('\n')) {
      // Multi-line comment toggle
      const lines = selectedText.split('\n')
      const hasComments = lines.every(line => line.trim().startsWith(commentSymbol))
      
      let newLines
      if (hasComments) {
        // Remove comments
        newLines = lines.map(line => line.replace(new RegExp(`^(\\s*)${commentSymbol}\\s?`), '$1'))
      } else {
        // Add comments
        newLines = lines.map(line => line.replace(/^(\s*)/, `$1${commentSymbol} `))
      }
      
      this.replaceSelection(newLines.join('\n'))
    } else {
      // Single line comment toggle
      const currentLine = this.getCurrentLine()
      const lineStart = this.element.value.lastIndexOf('\n', start - 1) + 1
      const lineEnd = this.element.value.indexOf('\n', start)
      
      if (currentLine.trim().startsWith(commentSymbol)) {
        // Remove comment
        const newLine = currentLine.replace(new RegExp(`^(\\s*)${commentSymbol}\\s?`), '$1')
        this.element.value = this.element.value.substring(0, lineStart) + 
                            newLine + 
                            this.element.value.substring(lineEnd === -1 ? this.element.value.length : lineEnd)
      } else {
        // Add comment
        const indent = this.getIndentation(currentLine)
        const newLine = currentLine.replace(/^(\s*)/, `$1${commentSymbol} `)
        this.element.value = this.element.value.substring(0, lineStart) + 
                            newLine + 
                            this.element.value.substring(lineEnd === -1 ? this.element.value.length : lineEnd)
      }
    }
  }
  
  getCurrentLine() {
    const start = this.element.selectionStart
    const lineStart = this.element.value.lastIndexOf('\n', start - 1) + 1
    const lineEnd = this.element.value.indexOf('\n', start)
    return this.element.value.substring(lineStart, lineEnd === -1 ? this.element.value.length : lineEnd)
  }
  
  getIndentation(line) {
    const match = line.match(/^(\s*)/)
    return match ? match[1] : ''
  }
  
  insertText(text) {
    const start = this.element.selectionStart
    this.element.value = this.element.value.substring(0, start) + 
                        text + 
                        this.element.value.substring(this.element.selectionEnd)
    this.element.selectionStart = this.element.selectionEnd = start + text.length
  }
  
  replaceSelection(text) {
    const start = this.element.selectionStart
    const end = this.element.selectionEnd
    this.element.value = this.element.value.substring(0, start) + 
                        text + 
                        this.element.value.substring(end)
  }
  
  autoResize() {
    this.element.style.height = 'auto'
    this.element.style.height = (this.element.scrollHeight) + 'px'
  }
  
  updateLineNumbers() {
    // This could be enhanced with actual line numbers display
    const lines = this.element.value.split('\n').length
    this.element.setAttribute('data-lines', lines)
  }
}