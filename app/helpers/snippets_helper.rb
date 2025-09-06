module SnippetsHelper
  def syntax_highlighted_code(code, language, options = {})
    truncate_length = options[:truncate] || nil
    code_to_highlight = truncate_length ? code.truncate(truncate_length, separator: "\n") : code
    
    begin
      lexer = Rouge::Lexer.find(language) || Rouge::Lexer.find('text')
      formatter = Rouge::Formatters::HTML.new
      highlighted = formatter.format(lexer.lex(code_to_highlight))
      
      content_tag :div, class: 'syntax-highlighted' do
        content_tag :pre, class: 'highlight' do
          raw highlighted
        end
      end
    rescue
      content_tag :div, class: 'syntax-highlighted' do
        content_tag :pre, class: 'highlight' do
          content_tag :code, code_to_highlight
        end
      end
    end
  end
end
