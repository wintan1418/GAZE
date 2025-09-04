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
  
  connect() {
    this.initializeCodeMirror()
  }
  
  disconnect() {
    if (this.editor) {
      this.editor.destroy()
    }
  }
  
  initializeCodeMirror() {
    const initialValue = this.textareaTarget.value || "// Welcome to GAZE Code Editor\n// Start typing your code here...\n"
    const language = this.getLanguageExtension()
    
    const state = EditorState.create({
      doc: initialValue,
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
    
    this.editor = new EditorView({
      state,
      parent: this.containerTarget
    })
    
    // Hide the original textarea
    this.textareaTarget.style.display = 'none'
    
    // Sync on language change
    if (this.hasLanguageTarget) {
      this.languageTarget.addEventListener('change', () => {
        this.updateLanguage()
      })
    }
    
    // Sync before form submission
    this.element.closest('form').addEventListener('submit', () => {
      this.syncToTextarea()
    })
  }
  
  getLanguageExtension() {
    const language = this.hasLanguageTarget ? this.languageTarget.value : 'javascript'
    
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
    if (this.editor) {
      this.textareaTarget.value = this.editor.state.doc.toString()
    }
  }
}