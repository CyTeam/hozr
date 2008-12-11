module DoctorsHelper
  def select_doctors(params = {})
    method = params[:method] ? params[:method] : :doctor_id
    collection = Doctor.find(:all, :include => :praxis, :order => 'family_name, given_name', :conditions => {:active => true}).collect { |m| [ [ m.family_name, m.given_name ].join(", ") + " (#{m.praxis.locality})", m.id ] }
    
    if params[:form]
      params[:form].select method, collection, :label => 'Arzt', :include_blank => true
    elsif params[:object]
      select params[:object], method, collection, :include_blank => true
    else
      raise "Missing :form or :object parameter when calling 'select_doctors'"
    end
  end
end
