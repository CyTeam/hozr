module InsurancesHelper
  def insurances_collection
    Insurance.includes(:vcard => :address).order('vcards.full_name')
  end
end
