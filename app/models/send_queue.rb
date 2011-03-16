class SendQueue < ActiveRecord::Base
  belongs_to :mailing

  # Helpers
  def to_s
    # 13.2.2011: 5 Resultate für Muster per e-mail
    "%s: %i Resultate für %s per %s" % [created_at, mailing.cases.count, channel.to_s, mailing.doctor.to_s]
  end
end
