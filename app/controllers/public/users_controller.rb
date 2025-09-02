class Public::UsersController < Public::BaseController
  def show
    @user = User.find_by!(username: params[:username])
    @pagy, @snippets = pagy(@user.snippets.public_snippets.includes(:tags).recent)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'User not found.'
  end
end