class DelieveryReturn < ActiveRecord::Base
  belongs_to :bill, :class_name => 'Praxistar::Bill'
  belongs_to :cyto_case, :class_name => 'Cyto::Case', :foreign_key => 'case_id'

  def before_validation_on_create
    self.cyto_case ||= self.bill.cyto_case
  end

  # Cleanup task, called from cronjob
  def self.close_payed
    for d in DelieveryReturn.find(:all, :conditions => ['closed_at IS NULL'])
      d.closed_at = DateTime.now if (d.cyto_case.bill and (d.cyto_case.bill.payment_state == "payed"))
      d.save
    end
  end
end
