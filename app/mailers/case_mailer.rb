class CaseMailer < ActionMailer::Base
  helper :cases, :application, :has_vcards

  def report(a_case)
    @case = a_case

    prawn_options = { :page_size => 'A4' }
    attachments[a_case.pdf_name] = ResultReport.new(prawn_options).to_pdf(a_case)

    # Collect all
    copy_tos = a_case.case_copy_tos.by_channel('email')
    cc_emails = copy_tos.collect(&:person).collect(&:vcard).collect(&:contacts).flatten.select{|contact| contact.phone_number_type == 'E-Mail'}.map(&:to_s)

    # TODO: respect mail.result_report.bcc setting
    mail(
      :to => a_case.doctor.email,
      :cc => cc_emails,
      :bcc => @case.screener.tenant.person.vcard.contacts.by_type('E-Mail').first,
      :from => @case.screener.tenant.person.vcard.contacts.by_type('E-Mail').first,
      :subject => "Resultat #{a_case.to_s}"
    )
  end
end
