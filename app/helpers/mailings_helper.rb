module MailingsHelper
  def link_to_send_by(mailing, channel)
#    link_to_remote(t(channel, :scope => 'channel'), :update => "mailing_log_#{mailing.id}", :loading => "Element.show('#{loading_indicator_id({:id => "mailing_#{mailing.id}"})}')", :url => {:controller => :mailings, :action => :send_by, :channel => channel, :id => mailing }) if mailing.doctor.wants(channel)
  end
end
