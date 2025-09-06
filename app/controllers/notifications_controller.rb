class NotificationsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @pagy, @notifications = pagy(
      current_user.notifications
        .includes(:actor, :notifiable)
        .recent,
      items: 20
    )
    
    # Mark all notifications as read when viewing
    current_user.notifications.unread.update_all(read_at: Time.current)
  end
  
  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!
    redirect_back(fallback_location: notifications_path)
  end
  
  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    redirect_to notifications_path, notice: 'All notifications marked as read'
  end
end