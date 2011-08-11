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
    alias_action [:case_label, :casel_label_print, :post_label, :post_label_print], :to => :label_print

    return unless user
    
    if user.role? :sysadmin
      can :manage, :all
      cannot :sign, Case
    elsif user.role? :admin
      can :label_print, :label_print
      can :print, :order_form
      can :all, :admin
      can :manage, Case
      cannot [:destroy, :sign], Case
    elsif user.role? :zyto
      can :manage, Case
      cannot :destroy, Case
    else
      can [:show, :update], User, :id => user.id
    end
  end
end
