class Doctor < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :praxis, :class_name => 'Vcard', :foreign_key => 'praxis_vcard'
  belongs_to :private, :class_name => 'Vcard', :foreign_key => 'private_vcard'
  
  has_many :cases
  
  def family_name
    praxis.family_name || ""
  end

  def family_name=(name)
    praxis.family_name = name
  end

  def given_name
    praxis.given_name || ""
  end

  def given_name=(name)
    praxis.given_name = name
  end

  def name
    praxis.full_name || ""
  end
end
