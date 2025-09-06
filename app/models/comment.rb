class Comment < ApplicationRecord
  # Associations
  belongs_to :snippet
  belongs_to :user
  
  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  
  # Callbacks
  after_create :create_notification
  
  # Instance methods
  def can_be_deleted_by?(user)
    return false unless user
    self.user == user || snippet.user == user
  end
  
  private
  
  def create_notification
    NotificationService.notify_snippet_commented(self)
  end
end
