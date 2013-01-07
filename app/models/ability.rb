# encoding: utf-8

# Defines abilities
#
# This class defines the abilities available to User Roles.
# Will be used by CanCan.
class Ability
  # Aspects
  include CanCan::Ability

  # Available roles
  def self.roles
    Role.pluck(:name)
  end

  # Prepare roles to show in select inputs etc.
  def self.roles_for_collection
    self.roles.map{|role| [I18n.translate(role, :scope => 'cancan.roles'), role]}
  end

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
      can :print, :doctor_order_form
      can :manage, Mailing
      can :manage, Case
      can :manage, Patient
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
