# encoding: UTF-8

module PeopleHelper
  def contact_icon(contact)
    case contact.phone_number_type
    when 'E-Mail'
      return 'icon-envelope'
    when 'Fax', 'fax'
      return 'icon-print'
    when 'Handy', 'mobile', 'phone', 'Tel. geschäft', 'Tel. privat'
      return 'icon-headphones'
    end
  end
end
