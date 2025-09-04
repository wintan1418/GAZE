module ApplicationHelper
  include Pagy::Frontend
  
  def language_options_for_select
    [
      ['Ruby', 'ruby'],
      ['JavaScript', 'javascript'],
      ['TypeScript', 'typescript'],
      ['Python', 'python'],
      ['Java', 'java'],
      ['C#', 'csharp'],
      ['C++', 'cpp'],
      ['C', 'c'],
      ['Go', 'go'],
      ['Rust', 'rust'],
      ['PHP', 'php'],
      ['Swift', 'swift'],
      ['Kotlin', 'kotlin'],
      ['HTML', 'html'],
      ['CSS', 'css'],
      ['SQL', 'sql'],
      ['Shell', 'shell'],
      ['YAML', 'yaml'],
      ['JSON', 'json'],
      ['XML', 'xml'],
      ['Markdown', 'markdown'],
      ['Other', 'other']
    ]
  end
  
  def syntax_highlight(code, language)
    # Ensure code has proper line breaks
    formatted_code = code.strip
    
    # Use HTMLLineTable for better line numbers
    formatter = Rouge::Formatters::HTMLLineTable.new(
      Rouge::Formatters::HTML.new(css_class: 'highlight'),
      css_class: 'highlight-table',
      gutter_class: 'gutter',
      code_class: 'code',
      table_class: 'rouge-table',
      line_id: 'L%i',
      line_class: 'lineno',
      start_line: 1
    )
    
    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
    formatter.format(lexer.lex(formatted_code))
  end
end
