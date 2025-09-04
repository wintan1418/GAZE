class Comment < ApplicationRecord
  # Associations
  belongs_to :snippet
  belongs_to :user
  
  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  
  # Instance methods
  def can_be_deleted_by?(user)
    return false unless user
    self.user == user || snippet.user == user
  end
end
