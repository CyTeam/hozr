class Insurance < ActiveRecord::Base
  belongs_to :vcard

  def name
    vcard.family_name
  end

  def name=(name)
    vcard.family_name = name
  end
end
