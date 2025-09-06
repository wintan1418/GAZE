import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }
  
  connect() {
    console.log("Live search controller connected")
    this.timeout = null
    this.hideResults()
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  search(event) {
    console.log("Search triggered with:", event.target.value)
    
    // Clear existing timeout
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    const query = event.target.value.trim()
    
    // If query is empty or too short, hide results
    if (query.length < 2) {
      this.hideResults()
      return
    }

    // Debounce the search
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }

  async performSearch(query) {
    try {
      console.log("Performing search for:", query)
      
      // Build URL
      const url = `${this.urlValue}?q=${encodeURIComponent(query)}&format=json`
      
      // Show loading
      this.showLoading()

      // Perform search
      const response = await fetch(url, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`)
      }

      const data = await response.json()
      console.log("Search results:", data)
      this.displayResults(data, query)
      
    } catch (error) {
      console.error('Search error:', error)
      this.showError()
    }
  }

  displayResults(data, query) {
    if (!this.hasResultsTarget) return

    if (data.snippets && data.snippets.length > 0) {
      let html = `
        <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 max-h-80 overflow-y-auto">
          <div class="px-4 py-2 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
            <p class="text-xs text-gray-600 dark:text-gray-400">
              ${data.snippets.length} results for "${query}"
            </p>
          </div>
          <div class="divide-y divide-gray-200 dark:divide-gray-700">
      `

      data.snippets.forEach(snippet => {
        html += `
          <a href="/snippets/browse/${snippet.slug}" class="block px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
            <p class="font-medium text-gray-900 dark:text-white text-sm">${snippet.title}</p>
            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">by ${snippet.user_name} • ${snippet.language}</p>
          </a>
        `
      })

      html += `</div></div>`

      this.resultsTarget.innerHTML = html
      this.showResults()
    } else {
      this.showNoResults(query)
    }
  }

  showNoResults(query) {
    this.resultsTarget.innerHTML = `
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-4 text-center">
        <p class="text-gray-500 dark:text-gray-400 text-sm">No results for "${query}"</p>
      </div>
    `
    this.showResults()
  }

  showLoading() {
    this.resultsTarget.innerHTML = `
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-4 text-center">
        <p class="text-gray-500 dark:text-gray-400 text-sm">Searching...</p>
      </div>
    `
    this.showResults()
  }

  showError() {
    this.resultsTarget.innerHTML = `
      <div class="bg-white dark:bg-gray-800 rounded-xl shadow-lg border border-gray-200 dark:border-gray-700 p-4 text-center">
        <p class="text-red-500 dark:text-red-400 text-sm">Search failed</p>
      </div>
    `
    this.showResults()
  }

  showResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.classList.remove('hidden')
    }
  }

  hideResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.classList.add('hidden')
    }
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideResults()
    }
  }
}