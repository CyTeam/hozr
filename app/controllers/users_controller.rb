# encoding: utf-8

# Provides a user/account management interface.
class UsersController < AuthorizedController
  def index
    @users = User.where(:object_type => 'Employee').paginate(:page => params[:page])
  end

  # Actions
  def update
    @user = User.find(params[:id])
    
    # Don't try to update password if not provided
    if params[:user][:password].blank?
      [:password, :password_confirmation, :current_password].collect{|p| params[:user].delete(p) }
    end

    # Test if user is allowed to change roles
    params[:user].delete(:role_texts) unless can? :manage, Role

    update!
  end

  def current
    redirect_to current_user
  end

  def unlock
    @user = User.find(params[:id])
    
    @user.unlock_token = nil
    @user.locked_at = nil
    
    @user.save
    
    redirect_to users_path
  end

  def lock
    @user = User.find(params[:id])
    
    @user.locked_at = DateTime.now
    
    @user.save
    
    redirect_to users_path
  end
end
