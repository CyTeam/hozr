class Task < ActiveRecord::Base
  def as_wage_units
    return amount * factor
  end
end
