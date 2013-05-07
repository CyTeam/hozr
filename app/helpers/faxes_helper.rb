module FaxesHelper
  def fax_collection
    Doctor.all.collect do |person|
      fax_contact = person.vcard.contacts.where(:phone_number_type => ['Fax', 'fax']).first
      number = fax_contact.try(:number)

      {:id => person.id, :text => person.to_s, :number => number}
    end
  end
end
