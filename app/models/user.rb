class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  belongs_to :object, :polymorphic => true

  validates_uniqueness_of   :login
  
  # Helpers
  def to_s
    if object
      return object.name
    else
      return email
    end
  end
end
