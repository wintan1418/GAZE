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
    
    formatter = Rouge::Formatters::HTMLTable.new(
      Rouge::Formatters::HTML.new(css_class: 'highlight'),
      css_class: 'highlight',
      gutter_class: 'gl',
      code_class: 'code'
    )
    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
    formatter.format(lexer.lex(formatted_code))
  end
end
