# Defines abilities
#
# This class defines the abilities available to User Roles.
# Will be used by CanCan.
class Ability
  # Aspects
  include CanCan::Ability

  # Main role/ability definitions.
  def initialize(user)
    alias_action :index, :to => :list
    alias_action [:show, :current], :to => :show
    
    return unless user
    
    if user.role? :sysadmin
      can :manage, :all
    else
      can [:show, :update], User, :id => user.id
    end
  end
end
