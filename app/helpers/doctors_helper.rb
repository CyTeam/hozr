module DoctorsHelper
  def doctors_collection
    Doctor.active.includes(:praxis => :address).order('vcards.family_name, vcards.given_name').collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.locality})", m.id ] }
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
