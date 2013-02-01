# encoding: utf-8

class EmployeesController < PeopleController
  defaults :resource_class => Employee
end
