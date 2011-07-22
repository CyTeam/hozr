class SendQueue < ActiveRecord::Base
  belongs_to :mailing

  # Scopes
  scope :sent, where("sent_at IS NOT NULL")
  scope :unsent, where(:sent_at => nil)
  scope :by_channel, lambda {|channel| where(:channel => channel) }

  # Helpers
  def to_s
    # 13.2.2011: 5 Resultate für Muster per e-mail
    "%s: %i Resultate für %s per %s" % [created_at, mailing.cases.count, channel.to_s, mailing.doctor.to_s]
  end

  def sent?
    ! sent_at.nil?
  end
  
  # Actions
  def print
    mailing.print('A5', 'hpT2', 'hpT3')

    self.sent_at = DateTime.now
    save
  end
end
