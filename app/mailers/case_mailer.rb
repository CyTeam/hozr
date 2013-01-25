class CaseMailer < ActionMailer::Base
  helper :cases, :application, :has_vcards

  def report(a_case)
    @case = a_case

    prawn_options = { :page_size => 'A4' }
    attachments[a_case.pdf_name] = ResultReport.new(prawn_options).to_pdf(a_case)

    mail(
      :to => a_case.doctor.email,
      :from => @case.screener.tenant.person.vcard.contacts.by_type('E-Mail').first,
      :subject => "Resultat #{a_case.to_s}"
    )
  end
end
