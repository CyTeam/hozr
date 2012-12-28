# encoding: utf-8

class Employee < Person
  # Access restrictions
  attr_accessible :code, :born_on, :workload
end
