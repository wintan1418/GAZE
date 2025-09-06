class NotificationService
  def self.create_notification(user:, actor:, notifiable:, action:, data: {})
    # Don't create notification if actor is the same as the user
    return if user == actor
    
    # Check if user wants this type of notification
    settings = user.notification_setting
    return unless settings&.should_notify?(action)
    
    # Create the notification
    user.notifications.create!(
      actor: actor,
      notifiable: notifiable,
      action: action,
      data: data
    )
  end
  
  # Specific helper methods
  def self.notify_snippet_commented(comment)
    create_notification(
      user: comment.snippet.user,
      actor: comment.user,
      notifiable: comment.snippet,
      action: 'commented',
      data: { comment_id: comment.id }
    )
  end
  
  def self.notify_snippet_starred(star)
    create_notification(
      user: star.snippet.user,
      actor: star.user,
      notifiable: star.snippet,
      action: 'starred',
      data: { star_id: star.id }
    )
  end
  
  def self.notify_snippet_viewed(snippet, viewer)
    # Only notify if viewer is signed in and different from owner
    return unless viewer && viewer != snippet.user
    
    create_notification(
      user: snippet.user,
      actor: viewer,
      notifiable: snippet,
      action: 'viewed'
    )
  end
  
  def self.notify_snippet_copied(snippet, copier)
    # Only notify if copier is signed in and different from owner
    return unless copier && copier != snippet.user
    
    create_notification(
      user: snippet.user,
      actor: copier,
      notifiable: snippet,
      action: 'copied'
    )
  end
end