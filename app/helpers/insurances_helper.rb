# encoding: utf-8'
module InsurancesHelper
  def insurances_collection
    Insurance.includes(:vcard => :address).order('vcards.full_name').map{|insurance| [insurance.to_s, insurance.id]}
  end
end
