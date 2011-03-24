class Doctor < ActiveRecord::Base
  belongs_to :vcard
  belongs_to :praxis, :class_name => 'Vcard', :foreign_key => 'praxis_vcard'
  belongs_to :private, :class_name => 'Vcard', :foreign_key => 'private_vcard'
  belongs_to :billing_doctor, :class_name => 'Doctor'
  
  has_many :cases, :class_name => 'Case'
  has_many :patients
  has_many :mailings
  has_and_belongs_to_many :offices

  # CyLab
  # =====
  has_one :user, :as => :object
  delegate :email, :email=, :to => :user

  has_and_belongs_to_many :offices

  # HL7
  named_scope :wanting_hl7, :include => :user, :conditions => ["users.wants_hl7 = ?", true]
  has_many :undelivered_hl7, :class_name => 'Mailing', :conditions => ["hl7_delivered_at IS NULL"]
  delegate :wants_hl7, :to => :user
  def wants_hl7=(value)
    undelivered_hl7.update_all('hl7_delivered_at = now()')

    # Delegate to user
    user.wants_hl7 = value
    user.save
  end

  # Email
  named_scope :wanting_emails, :include => :user, :conditions => ["users.wants_email = ?", true]
  has_many :undelivered_mailings, :class_name => 'Mailing', :conditions => ["email_delivered_at IS NULL"]
  delegate :wants_email, :wants_email=, :to => :user
  def wants_email=(value)
    undelivered_mailings.update_all('email_delivered_at = now()')
    cases.undelivered.update_all('email_sent_at = now()')

    # Delegate to user
    user.wants_email = value
    user.save
  end

  # Printing
  named_scope :wanting_prints, :include => :user, :conditions => ["users.wants_prints = ?", true]
  has_many :undelivered_prints, :class_name => 'Mailing', :conditions => ["printed_at IS NULL"]
  delegate :wants_prints, :wants_prints=, :to => :user
  def wants_prints=(value)
    undelivered_prints.update_all('printed_at = now()')
    
    # Delegate to user
    user.wants_prints = value
    user.save
  end

  def wants_prints
    if user
      user.wants_prints
    else
      true
    end
  end
    
  # Helpers
  def to_s
    name
  end
  
  # Hozr
  def family_name
    praxis.family_name || ""
  end

  def family_name=(name)
    praxis.family_name = name
  end

  def given_name
    praxis.given_name || ""
  end

  def given_name=(name)
    praxis.given_name = name
  end

  def name
    praxis.full_name || ""
  end

  def billing_doctor_id
    read_attribute(:billing_doctor_id) || id
  end

  # Customers support
  def uid
    name.tr(' -', '_').underscore
  end

  def uidNumber
    sprintf("%03.0f", id)
  end

  # Password
  def password=(value)
    write_attribute(:password, Digest::SHA256.hexdigest(value))
  end

  # Email
  def deliver_mailings_by_email
    for mailing in undelivered_mailings
      mailing.deliver_by_email
      mailing.email_delivered_at = Time.now
      mailing.save
    end
  end

  def self.deliver_all_mailings_by_email
    # TODO: use self.wanting_emails as in CyLab
    for doctor in self.find :all, :include => :user, :conditions => ["users.wants_email = ?", true]
      doctor.deliver_mailings_by_email
    end
  end
end
