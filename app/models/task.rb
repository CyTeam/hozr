class Task < ActiveRecord::Base
  belongs_to :employee
  
  def as_wage_units
    return amount * factor
  end

  def due_on=(value)
    write_attribute(:due_on, Date.parse_date(value))
  end
end
