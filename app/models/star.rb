class Star < ApplicationRecord
  belongs_to :user
  belongs_to :snippet
  
  validates :user_id, uniqueness: { scope: :snippet_id }
  
  scope :recent, -> { order(created_at: :desc) }
  
  # Callbacks
  after_create :create_notification
  
  private
  
  def create_notification
    NotificationService.notify_snippet_starred(self)
  end
end
