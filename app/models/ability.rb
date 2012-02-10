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
    alias_action [:case_label, :case_label_print, :post_label, :post_label_print], :to => :label_print

    return unless user
    
    if user.role? :sysadmin
      can :manage, :all
    end
    if user.role? :admin
      can :label_print, :label_print
      can :print, :order_form
      can :manage, Mailing
      can :manage, Case
    end
    if user.role? :zyto
      can :manage, Case
    end

    # Allow setting password
    can [:show, :update], User, :id => user.id

    cannot :destroy, Case unless user.role? :sysadmin
    cannot :sign, Case unless user.role? :zyto
  end
end
