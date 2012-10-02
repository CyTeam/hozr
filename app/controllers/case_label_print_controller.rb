# encoding: utf-8'
class CaseLabelPrintController < LabelPrintController
  # Case labels
  # ===========
  def print
    start_praxistar_eingangsnr = params[:start_praxistar_eingangsnr]
    end_praxistar_eingangsnr = params[:end_praxistar_eingangsnr]
    @cases = Case.for_second_entry.where("praxistar_eingangsnr BETWEEN ? AND ?", start_praxistar_eingangsnr, end_praxistar_eingangsnr)

    do_print
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
