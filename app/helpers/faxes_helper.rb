module FaxesHelper
  def fax_collection
    Doctor.all.collect do |person|
      fax_contact = person.vcard.contacts.where(:phone_number_type => ['Fax', 'fax']).first
      number = fax_contact.try(:number)

      {:id => person.id, :text => person.to_s, :number => number}
    end
  end

  def fax_state_label(fax)
    case fax.state.to_s
    when 'pending'
      boot_label('in arbeit...', :warning)
    when 'sent'
      boot_label('versandt', :success)
    when 'failed'
      boot_label('fehlgeschlagen', :important)
    end
  end
end
