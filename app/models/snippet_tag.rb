class SnippetTag < ApplicationRecord
  # Associations
  belongs_to :snippet
  belongs_to :tag
  
  # Validations
  validates :snippet_id, uniqueness: { scope: :tag_id }
end
