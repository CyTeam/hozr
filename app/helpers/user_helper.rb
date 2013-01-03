module UserHelper
  def user_object_collection
    [
      [t_model(Doctor), Doctor.all.map{|u| [u.to_s, "Doctor:#{u.id}"]}],
      [t_model(Employee), Employee.all.map{|u| [u.to_s, "Employee:#{u.id}"]}]
    ]
  end
end

