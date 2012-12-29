# encoding: utf-8

class Employee < Person
  # Access restrictions
  attr_accessible :code, :born_on, :workload

  def born_on
    date_of_birth
  end
end
