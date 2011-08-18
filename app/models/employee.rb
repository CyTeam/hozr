class Employee < ActiveRecord::Base
  belongs_to :work_vcard, :class_name => 'Vcard', :foreign_key => :work_vcard_id
  belongs_to :private_vcard, :class_name => 'Vcard', :foreign_key => :private_vcard_id

  # Proxies
  def name
    (work_vcard || private_vcard).try(:full_name)
  end
end
