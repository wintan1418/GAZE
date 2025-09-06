class EditRequest < ApplicationRecord
  # Associations
  belongs_to :snippet
  belongs_to :requester, class_name: 'User'
  belongs_to :approver, class_name: 'User', optional: true
  
  # Enums
  enum status: { pending: 'pending', approved: 'approved', denied: 'denied', revoked: 'revoked' }
  
  # Validations
  validates :message, length: { maximum: 500 }
  validates :status, presence: true
  validates :requester_id, uniqueness: { scope: :snippet_id, message: "You already have a pending request for this snippet" }
  validate :cannot_request_own_snippet
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(snippet: user.snippets) }
  
  # Instance methods
  def can_be_approved_by?(user)
    return false unless user
    snippet.user == user && pending?
  end
  
  def approve!(approver)
    self.approver = approver
    self.status = 'approved'
    save!
  end
  
  def deny!(approver)
    self.approver = approver
    self.status = 'denied'
    save!
  end
  
  private
  
  def cannot_request_own_snippet
    return unless snippet && requester
    
    if snippet.user == requester
      errors.add(:requester, "cannot request edit permission for own snippet")
    end
  end
end
