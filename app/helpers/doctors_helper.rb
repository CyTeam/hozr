module DoctorsHelper
  def select_doctors(params = {})
    method = params[:method] ? params[:method] : :doctor_id
    collection = Doctor.find(:all, :include => :praxis, :order => 'family_name, given_name').collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.locality})", m.id ] }
    
    if params[:form]
      params[:form].select method, collection, :label => 'Arzt'
    elsif params[:object]
      select params[:object], method, collection
    else
      raise "Missing :form or :object parameter when calling 'select_doctors'"
    end
  end
end
