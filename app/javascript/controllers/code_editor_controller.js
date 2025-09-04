import { Controller } from "@hotwired/stimulus"
import { EditorView, basicSetup } from "codemirror"
import { EditorState } from "@codemirror/state"
import { oneDark } from "@codemirror/theme-one-dark"
import { javascript } from "@codemirror/lang-javascript"
import { python } from "@codemirror/lang-python"
import { html } from "@codemirror/lang-html"
import { css } from "@codemirror/lang-css"
import { json } from "@codemirror/lang-json"

export default class extends Controller {
  static targets = ["container", "textarea", "language"]
  static values = { mode: String, readonly: Boolean, code: String }
  
  connect() {
    this.initializeCodeMirror()
  }
  
  disconnect() {
    if (this.editor) {
      this.editor.destroy()
    }
  }
  
  initializeCodeMirror() {
    // Use code from data value if available, otherwise from textarea
    let initialValue
    if (this.hasCodeValue) {
      initialValue = this.codeValue
    } else if (this.hasTextareaTarget) {
      initialValue = this.textareaTarget.value
    } else {
      initialValue = "// Welcome to GAZE Code Editor\n// Start typing your code here...\n"
    }
    const language = this.getLanguageExtension()
    const isReadonly = this.hasReadonlyValue ? this.readonlyValue : false
    
    // Base extensions
    const extensions = [
      basicSetup,
      language,
      oneDark,
      EditorView.theme({
        "&": {
          fontSize: "14px",
          fontFamily: "'JetBrains Mono', 'Fira Code', 'Monaco', 'Consolas', monospace"
        },
        ".cm-content": {
          padding: "16px",
          minHeight: isReadonly ? "auto" : "400px"
        },
        ".cm-focused": {
          outline: "none"
        },
        ".cm-editor": {
          borderRadius: isReadonly ? "8px" : "0 0 8px 8px"
        },
        ".cm-scroller": {
          fontSize: "14px",
          lineHeight: "1.5"
        }
      })
    ]
    
    // Add readonly extension if needed
    if (isReadonly) {
      extensions.push(EditorState.readOnly.of(true))
    } else {
      extensions.push(EditorView.updateListener.of((update) => {
        if (update.docChanged) {
          this.syncToTextarea()
        }
      }))
    }
    
    const state = EditorState.create({
      doc: initialValue,
      extensions: extensions
    })
    
    // Find container target
    const container = this.hasContainerTarget ? this.containerTarget : this.element
    
    // Hide any existing content (fallback pre elements) before creating editor
    const existingContent = container.children
    for (let i = 0; i < existingContent.length; i++) {
      existingContent[i].style.display = 'none'
    }
    
    this.editor = new EditorView({
      state,
      parent: container
    })
    
    // Hide the original textarea if it exists
    if (this.hasTextareaTarget) {
      this.textareaTarget.style.display = 'none'
    }
    
    if (!isReadonly) {
      // Sync on language change
      if (this.hasLanguageTarget) {
        this.languageTarget.addEventListener('change', () => {
          this.updateLanguage()
        })
      }
      
      // Sync before form submission
      const form = this.element.closest('form')
      if (form) {
        form.addEventListener('submit', () => {
          this.syncToTextarea()
        })
      }
    }
  }
  
  getLanguageExtension() {
    const language = this.hasModeValue ? this.modeValue : 
                    (this.hasLanguageTarget ? this.languageTarget.value : 'javascript')
    
    switch(language) {
      case 'javascript':
      case 'typescript':
        return javascript()
      case 'python':
        return python()
      case 'html':
        return html()
      case 'css':
        return css()
      case 'json':
        return json()
      default:
        return javascript()
    }
  }
  
  updateLanguage() {
    if (!this.editor) return
    
    const currentDoc = this.editor.state.doc.toString()
    const language = this.getLanguageExtension()
    
    const newState = EditorState.create({
      doc: currentDoc,
      extensions: [
        basicSetup,
        language,
        oneDark,
        EditorView.theme({
          "&": {
            fontSize: "14px",
            fontFamily: "'JetBrains Mono', 'Fira Code', 'Monaco', 'Consolas', monospace"
          },
          ".cm-content": {
            padding: "16px",
            minHeight: "400px"
          },
          ".cm-focused": {
            outline: "none"
          },
          ".cm-editor": {
            borderRadius: "0 0 8px 8px"
          },
          ".cm-scroller": {
            fontSize: "14px",
            lineHeight: "1.5"
          }
        }),
        EditorView.updateListener.of((update) => {
          if (update.docChanged) {
            this.syncToTextarea()
          }
        })
      ]
    })
    
    this.editor.setState(newState)
  }
  
  syncToTextarea() {
    if (this.editor && this.hasTextareaTarget) {
      this.textareaTarget.value = this.editor.state.doc.toString()
    }
  }
}