class Cyto::Bill < ActiveRecord::Base
  belongs_to :my_case, :class_name => 'Cyto::Case'
  belongs_to :praxistar_bill, :class_name => 'Praxistar::Bill', :foreign_key => 'praxistar_rechnungs_id'
  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt', :foreign_key => 'praxistar_leistungsblatt_id'
  
  def self.import(rechnungs_id)
    bill = self.new
    
    praxistar_bill = Praxistar::Bill.find(rechnungs_id)
    
    bill.praxistar_bill = praxistar_bill
    bill.amount = praxistar_bill.cu_TOTAL
    bill.praxistar_leistungsblatt_id = praxistar_bill.Leistungsblatt_ID
    bill.is_storno = praxistar_bill.tf_Storno?
    bill.my_case = praxistar_bill.cyto_case
    
    bill.save
  end
end
