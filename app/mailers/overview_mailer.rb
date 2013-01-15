# encoding: UTF-8

class OverviewMailer < ActionMailer::Base
  def report(mailing)
    @mailing = mailing

    prawn_options = { :page_size => 'A4', :top_margin => 140, :left_margin => 60, :right_margin => 60, :bottom_margin => 100 }
    attachments['Resultate.pdf'] = MailingOverview.new(prawn_options).to_pdf(mailing)

    mail(
      :to => mailing.doctor.email,
      :from => 'lab@zytolabor.ch',
      :subject => "Resultat Übersicht"
    )
  end
end
