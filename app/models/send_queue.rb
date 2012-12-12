# encoding: utf-8

class SendQueue < ActiveRecord::Base
  belongs_to :mailing

  # Scopes
  scope :sent, where("sent_at IS NOT NULL")
  scope :unsent, where(:sent_at => nil)
  scope :by_channel, lambda {|channel| where(:channel => channel) }
  def self.by_state(state)
    case state.to_s
    when 'sent'
      sent
    when 'unsent'
      unsent
    else
      scoped
    end
  end

  # Helpers
  def to_s
    # 13.2.2011: 5 Resultate für Muster per e-mail
    "%s: %i Resultate für %s per %s" % [created_at, mailing.cases.count, channel.to_s, mailing.doctor.to_s]
  end

  # Actions
  def print(overview_printer, printer)
    mailing.print('A5', overview_printer, printer)

    self.sent_at = DateTime.now
    save
  end
end
