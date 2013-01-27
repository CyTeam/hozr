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

  def admin_abilities
    can :label_print, :label_print
    can :print, :doctor_order_form
    can :manage, Mailing
    can :manage, Case
    can :manage, Patient
    can :manage, OrderForm
  end

  def zyto_abilities
    can :sign, Case
  end

  def doctor_abilities
    can :review_done, Case, :review_at => nil
    can :reactivate, Case do |a_case|
      a_case.review_at
    end
  end

  # Main role/ability definitions.
  def initialize(user)
    alias_action :index, :to => :list
    alias_action [:show, :current], :to => :show
    alias_action [:case_label, :case_label_print, :post_label, :post_label_print], :to => :label_print

    return unless user

    if user.role? :admin
      admin_abilities
    end
    cannot :sign, Case
    if user.role? :zyto
      admin_abilities
      zyto_abilities
    end
    cannot :review_done, Case
    cannot :reactivate, Case
    if user.role? :doctor
      admin_abilities
      zyto_abilities
      doctor_abilities
    end

    cannot :destroy, Case
    if user.role? :sysadmin
      can :manage, :all
    end

    cannot :review_done, Case do |a_case|
      a_case.review_at
    end
    cannot :reactivate, Case do |a_case|
      a_case.review_at.nil?
    end

    # Allow setting password
    can [:show, :update], User, :id => user.id

  end
end
