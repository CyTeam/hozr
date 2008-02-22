class DelieveryReturn < ActiveRecord::Base
  belongs_to :bill, :class_name => 'Praxistar::Bill'
  belongs_to :cyto_case, :class_name => 'Cyto::Case', :foreign_key => 'case_id'

  def before_validation_on_create
    self.cyto_case ||= self.bill.cyto_case
  end
end
