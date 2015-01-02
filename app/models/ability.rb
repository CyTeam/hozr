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

  def admin_abilities(user)
    can :label_print, :label_print
    can :print, :doctor_order_form
    can :manage, Mailing
    can :manage, Case
    can :manage, CaseCopyTo
    can :manage, Patient
    can :manage, OrderForm
    can :manage, Doctor
  end

  def zyto_abilities(user)
    can :sign, Case
  end

  def doctor_abilities(user)
    can :review_done, Case, :review_at => nil
    can :reactivate, Case do |a_case|
      a_case.review_at
    end
  end

  def client_abilities(user)
    can :read, Case, :doctor_id => user.object.id
    can :download, Attachment do |attachment|
      attachment.object.doctor_id == user.object.id
    end
  end

  # Main role/ability definitions.
  def initialize(user)
    alias_action :index, :to => :list
    alias_action [:show, :current], :to => :show
    alias_action [:case_label, :case_label_print, :post_label, :post_label_print], :to => :label_print

    return unless user

    if user.role? :client
      client_abilities(user)
    end

    if user.role? :admin
      admin_abilities(user)
    end
    cannot :sign, Case
    if user.role? :zyto
      admin_abilities(user)
      zyto_abilities(user)
    end
    cannot :review_done, Case
    cannot :reactivate, Case
    if user.role? :doctor
      admin_abilities(user)
      zyto_abilities(user)
      doctor_abilities(user)
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
