class CollectionSnippet < ApplicationRecord
  # Associations
  belongs_to :collection
  belongs_to :snippet
  
  # Validations
  validates :collection_id, uniqueness: { scope: :snippet_id }
  
  # Callbacks
  validate :same_user_validation
  
  private
  
  def same_user_validation
    if collection && snippet && collection.user_id != snippet.user_id
      errors.add(:base, "Collection and snippet must belong to the same user")
    end
  end
end
