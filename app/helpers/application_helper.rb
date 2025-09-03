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
    formatter = Rouge::Formatters::HTML.new(
      css_class: 'highlight',
      line_numbers: true
    )
    lexer = Rouge::Lexer.find(language) || Rouge::Lexers::PlainText.new
    formatter.format(lexer.lex(code))
  end
end
