class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def profile
    @user = current_user
    @pagy, @snippets = pagy(@user.snippets.includes(:tags).recent)
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update(user_params)
      redirect_to user_profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :username, :bio, :avatar)
  end
end
