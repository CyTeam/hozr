# encoding: utf-8'
class CaseLabelPrintController < LabelPrintController
  # Case labels
  # ===========
  def form
    latest_code = current_tenant.settings['cache.case_label_print.last_case_code'] || ''
    next_case = Case.for_second_entry.where('praxistar_eingangsnr > ?', latest_code).first
    @first_case_code = next_case.code
    @last_case_code = Case.for_second_entry.last.code
  end

  def print
    start_praxistar_eingangsnr = params[:case_label][:start_praxistar_eingangsnr]
    end_praxistar_eingangsnr = params[:case_label][:end_praxistar_eingangsnr]
    @cases = Case.for_second_entry.where("praxistar_eingangsnr BETWEEN ? AND ?", start_praxistar_eingangsnr, end_praxistar_eingangsnr)

    do_print

    current_tenant.settings['cache.case_label_print.last_case_code'] = end_praxistar_eingangsnr
  end

  def print_case
    @cases = [Case.find(params[:id])]

    do_print
  end

  def print_p16
    @cases = Case.for_hpv_p16

    do_print
  end

  private
  def do_print
     # Cleanup table
    OtLabel.delete_all

    # Create new records
    for label in @cases
      OtLabel.create(
        :sys_id => label.id,
        :prax_nr => label.praxistar_eingangsnr,
        :doc_fname => label.doctor.family_name,
        :doc_gname => label.doctor.given_name,
        :pat_fname => label.patient.vcard.family_name,
        :pat_gname => label.patient.vcard.given_name,
        :pat_bday => label.patient.birth_date
      )
    end

    # Trigger printing
    trigger

    render 'print'
  end
end
