class NotificationSetting < ApplicationRecord
  belongs_to :user
  
  # Set default values
  before_create :set_defaults
  
  def should_notify?(action)
    case action
    when 'commented'
      push_comments?
    when 'starred'
      push_stars?
    when 'viewed'
      push_views?
    when 'copied'
      push_copies?
    else
      false
    end
  end
  
  private
  
  def set_defaults
    self.email_comments = true if email_comments.nil?
    self.email_stars = true if email_stars.nil?
    self.email_views = false if email_views.nil?
    self.email_copies = true if email_copies.nil?
    self.push_comments = true if push_comments.nil?
    self.push_stars = true if push_stars.nil?
    self.push_views = false if push_views.nil?
    self.push_copies = false if push_copies.nil?
  end
end
