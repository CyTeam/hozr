class Doctor < ActiveRecord::Base
  belongs_to :vcard

  def family_name
    vcard.family_name
  end

  def family_name=(name)
    vcard.family_name = name
  end

  def given_name
    vcard.given_name
  end

  def given_name=(name)
    vcard.given_name = name
  end
end
