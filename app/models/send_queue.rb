class SendQueue < ActiveRecord::Base
  belongs_to :mailing

  # Scopes
  named_scope :sent, :conditions => "sent_at IS NOT NULL"
  named_scope :unsent, :conditions => {:sent_at => nil}
  named_scope :by_channel, lambda {|channel| {:conditions => ["channel = ?", channel]} }

  # Helpers
  def to_s
    # 13.2.2011: 5 Resultate für Muster per e-mail
    "%s: %i Resultate für %s per %s" % [created_at, mailing.cases.count, channel.to_s, mailing.doctor.to_s]
  end

  # Actions
  def print
    command = "/usr/local/bin/hozr_print_result_mailing.sh #{mailing.id} '' #{( ENV['RAILS_ENV'] || 'development' )}"
    stream = open("|#{command}")
    output = stream.read
    
    self.sent_at = DateTime.now
    save
    
    return output
  end
end
