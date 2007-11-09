class Cyto::Bill < ActiveRecord::Base
  belongs_to :my_case, :class_name => 'Cyto::Case'
  belongs_to :praxistar_bill, :class_name => 'Praxistar::Bill', :foreign_key => 'praxistar_rechnungs_id'
  belongs_to :praxistar_leistungsblatt, :class_name => 'Praxistar::LeistungenBlatt', :foreign_key => 'praxistar_leistungsblatt_id'
  
  def self.import(from)
    bill = self.new
    
    if from.class == Praxistar::Bill
      praxistar_bill = Praxistar::Bill.find(from)
    else
      praxistar_bill = from
    end
    
    bill.praxistar_bill = praxistar_bill
    bill.amount = praxistar_bill.cu_TOTAL
    bill.praxistar_leistungsblatt_id = praxistar_bill.Leistungsblatt_ID
    bill.is_storno = praxistar_bill.tf_Storno?
    bill.my_case = praxistar_bill.cyto_case
    
    bill.save
  end

  def self.import_all_for_doctor(doctor_id)
    puts "doctor: #{Doctor.find(doctor_id).name}"
    praxistar_bills = Praxistar::Bill.find(:all, :conditions => ['Stellvertretung_ID = ?', doctor_id])
    i = 0
    for praxistar_bill in praxistar_bills
      i += 1
      self.import praxistar_bill
      puts i
    end

    praxistar_bills.size
  end
end
