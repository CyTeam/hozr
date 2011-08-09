class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable, :timeoutable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :login

  attr_accessible :object
  belongs_to :object, :polymorphic => true

  validates_uniqueness_of   :login
  
  attr_accessible :login

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
      return object.name
    else
      return email
    end
  end
end
