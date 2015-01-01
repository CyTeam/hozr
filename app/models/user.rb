# encoding: utf-8

class User < ActiveRecord::Base
  # Strategies
  devise :database_authenticatable, :recoverable, :trackable, :timeoutable, :lockable, :rememberable, :validatable

  # API
  devise :token_authenticatable
  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :login, :remember_me

  # Person
  attr_accessible :object
  belongs_to :object, :polymorphic => true
  accepts_nested_attributes_for :object
  attr_accessible :object_attributes
  attr_accessible :object_id, :object_type

  def object_reference
    "#{object_type}:#{object_id}"
  end
  def object_reference=(value)
    self.object_type, self.object_id = value.split(':')
  end
  attr_accessible :object_reference

  validates :login, :presence => true, :uniqueness => true

  attr_accessible :login

  # Tenancy
  belongs_to :tenant
  attr_accessible :tenant
  validates :tenant, :presence => true

  # Authorization roles
  has_and_belongs_to_many :roles, :autosave => true
  scope :by_role, lambda{|role| include(:roles).where(:name => role)}
  attr_accessible :role_texts

  def role?(role)
    !!self.roles.find_by_name(role.to_s)
  end

  def role_texts
    roles.map{|role| role.name}
  end

  def role_texts=(role_names)
    self.roles = Role.where(:name => role_names)
  end

  # Helpers
  def to_s
    if object
      return object.to_s
    else
      return email
    end
  end
end
