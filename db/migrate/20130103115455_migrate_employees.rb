class LegacyEmployee < ActiveRecord::Base
  self.table_name = 'employees'
  def work_vcard
    Vcard.find(work_vcard_id)
  end
end

class MigrateEmployees < ActiveRecord::Migration
  def up
    case_maps = {}

    LegacyEmployee.find_each do |employee|
      new_employee = Employee.create(:vcard => employee.work_vcard, :code => employee.code)

      case_maps[new_employee.id] = Case.where(:first_entry_by => employee.id)

      User.where(:object_type => 'Employee', :object_id => employee.id).update_all(:object_id => new_employee.id, :object_type => 'LegacyEmployee')
      User.where(:object_type => 'LegacyEmployee').update_all(:object_type => 'Person')
    end

    case_maps.each do |id, cases|
      cases.update_all(:first_entry_by => id)
      cases.update_all(:screener_id => id)
      cases.update_all(:review_by => id)
      cases.update_all(:hpv_p16_prepared_by => id)
    end
  end
end
