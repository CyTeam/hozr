# Users Controller
#
# Provides a user/account management interface.
class UsersController < AuthorizedController
  def index
    @users = User.where(:object_type => 'Employee').paginate(:page => params[:page])
  end

  # Actions
  def update
    # Preset role_texts to ensure it clears roles.
    params[:user][:role_texts] ||= []

    @user = User.find(params[:id])
    
    # Don't try to update password if not provided
    if params[:user][:password].blank?
      [:password, :password_confirmation, :current_password].collect{|p| params[:user].delete(p) }
    end

    update!
  end

  def current
    redirect_to current_user
  end
end
