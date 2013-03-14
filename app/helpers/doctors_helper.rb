# encoding: utf-8'
module DoctorsHelper
  def doctors_collection
    Doctor.active.includes(:vcards => :address).order('vcards.family_name, vcards.given_name').collect { |m| [ m.to_s(:select), m.id ] }
  end

  def doctor_channels_collection
    t('activerecord.attributes.doctor.channels_enum').invert
  end

  def select_doctors(params = {})
    method = params[:method] ? params[:method] : :doctor_id
    collection = doctors_collection

    if params[:form]
      params[:form].select method, collection, :label => 'Arzt', :include_blank => true
    elsif params[:object]
      select params[:object], method, collection, :include_blank => true
    else
      raise "Missing :form or :object parameter when calling 'select_doctors'"
    end
  end
end
