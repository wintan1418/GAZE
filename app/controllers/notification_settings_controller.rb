class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_notification_setting
  
  def show
    @notification_setting = current_user.notification_setting
  end
  
  def update
    @notification_setting = current_user.notification_setting
    
    if @notification_setting.update(notification_setting_params)
      redirect_to notification_settings_path, notice: 'Notification preferences updated successfully!'
    else
      render :show, status: :unprocessable_entity
    end
  end
  
  private
  
  def notification_setting_params
    params.require(:notification_setting).permit(
      :email_comments, :email_stars, :email_views, :email_copies,
      :push_comments, :push_stars, :push_views, :push_copies
    )
  end
  
  def ensure_notification_setting
    current_user.create_notification_setting! unless current_user.notification_setting
  end
end