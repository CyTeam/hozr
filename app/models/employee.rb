# encoding: utf-8

class Employee < Person
  # Access restrictions
  attr_accessible :born_on, :workload

  def born_on
    date_of_birth
  end

  def born_on=(value)
    date_of_birth = value
  end

  # User
  # =====
  has_one :user, :as => :object, :autosave => true
  attr_accessible :user
  has_many :roles, :through => :user
  scope :by_role, lambda {|role|
    includes(:roles).where('roles.name' => role)
  }

  # Tenant
  # ======
  has_one :tenant, :through => :user
end
