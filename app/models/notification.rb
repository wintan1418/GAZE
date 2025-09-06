class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, polymorphic: true
  belongs_to :notifiable, polymorphic: true
  
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }
  
  def read?
    read_at.present?
  end
  
  def unread?
    !read?
  end
  
  def mark_as_read!
    update(read_at: Time.current) if unread?
  end
  
  def message
    case action
    when 'commented'
      "#{actor.username} commented on your snippet \"#{notifiable.title}\""
    when 'starred'
      "#{actor.username} starred your snippet \"#{notifiable.title}\""
    when 'viewed'
      "#{actor.username} viewed your snippet \"#{notifiable.title}\""
    when 'copied'
      "#{actor.username} copied your snippet \"#{notifiable.title}\""
    else
      "#{actor.username} interacted with your snippet \"#{notifiable.title}\""
    end
  end
end
