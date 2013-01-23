# encoding: utf-8'

class CasesController < AuthorizedController
  def report
    @case = Case.find(params[:id])
    render 'report', :layout => false
  end

  # Navigation
  # ==========
  def history
    @case = Case.find(params[:id])
    redirect_to :controller => '/patients', :action => 'show', :id => @case.patient
  end

  def next_step
    @case ||= Case.find(params[:id])

    if @case.ready_for_first_entry
      redirect_to first_entry_case_path(@case)
    elsif @case.ready_for_second_entry or @case.ready_for_p16
      redirect_to second_entry_form_case_path(@case)
    else
      redirect_to @case
    end
  end

  # First Entry
  # ===========
  def first_entry_queue
    @cases = apply_scopes(Case).for_first_entry
    render 'entry_list'
  end

  def first_entry
    @case = Case.find(params[:id])

    # Header image size preferences
    @header_image_type = session[:header_image_type] || :head
  end

  def next_first_entry
    @case = Case.find(params[:id])

    if next_case = @case.next_case(:for_first_entry)
      redirect_to first_entry_case_path(next_case)
    else
      redirect_to first_entry_queue_cases_path
    end
  end

  # Classification Entry
  # ====================
  def classification_form
    @case = Case.find(params[:id])
  end

  def classification_update
    @case = Case.find(params[:id])

    classification = Classification.find(params[:case][:classification])
    @case.classification = classification
    @case.save

    next_step
  end

  # Second Entry
  # ============
  def second_entry_queue
    @cases = apply_scopes(Case).for_second_entry
    render 'entry_list'
  end

  def second_entry_form
    @case = Case.find(params[:id])

    if @case.classification
      case @case.classification.code
      when '2A', '2-3A'
        render :action => 'second_entry_agus_ascus_form'
      when 'mam', 'sput', 'extra'
        @case.screened_at ||= Date.today
        @case.screener = current_user.object
        render :action => 'show'
      end
    end
  end

  def second_entry_update
    @case = Case.find(params[:id])

    @case.screener = current_user.object
    @case.update_attributes(params[:case])

    case params[:commit]
    when "Erstellen"
      @case.save
      redirect_to @case
      # That's it if it's a normal PAP
      return
    when "P16+HPV"
      @case.needs_hpv = true
      @case.needs_p16 = true
      @case.screened_at = nil
    when "P16"
      @case.needs_p16 = true
      @case.screened_at = nil
    when "Review"
      @case = Case.find(params[:id])
      @case.screened_at = Time.now
      @case.screener = current_user.object
      @case.needs_review = true
    end

    # Common code for hpv, p16 and review.
    @case.save

    next_open = Case.first_entry_done.where("praxistar_eingangsnr > ?", @case.praxistar_eingangsnr).first
    if next_open.nil?
      redirect_to second_entry_queue_cases_path
    else
      redirect_to second_entry_form_case_path(next_open)
    end
  end

  def sign
    @case = Case.find(params[:id])
    @case.screened_at = Time.now
    @case.screener = current_user.object
    @case.finding_text = params[:case][:finding_text] unless params[:case].nil? or params[:case][:finding_text].nil?

    # Check if case needs review
    low_classifications = ['1', '2']
    high_classifications = ['3L', '3M', '3S', '3M-c1-2', '3S-c2-3', '4', '5']

    previous_case = @case.patient.cases[1]
    if previous_case and not (previous_case.classification.nil?)
      # Sudden jump from PAP I/II to CIN I-II and higher
      low_to_high = (low_classifications.include?(previous_case.classification.code) and high_classifications.include?(@case.classification.code))
      high_to_low = (high_classifications.include?(previous_case.classification.code) and low_classifications.include?(@case.classification.code))
    end

    # Higher than Cin I-II
    high = high_classifications.include?(@case.classification.code)

    @case.needs_review = (low_to_high or high_to_low or high)

    if @case.needs_p16? or @case.needs_hpv?
      @case.delivered_at = nil
      @case.save

      redirect_to :action => 'hpv_p16_queue'
    else
      @case.save

      # Jump to next case
      next_open = Case.for_second_entry.where("praxistar_eingangsnr > ?", @case.praxistar_eingangsnr).first

      if next_open.nil?
        redirect_to second_entry_queue_cases_path
      else
        redirect_to second_entry_form_case_path(next_open)
      end
    end
  end

  # Review Queue
  # ============
  def review_queue
    @cases = apply_scopes(Case).for_review
    render 'index'
  end

  def review_done
    @case = Case.find(params[:id])
    @case.needs_review = false

    @case.review_by = current_user.object
    @case.review_at = Time.now

    @case.save!

    redirect_to :action => :review_queue
  end

  # Printing
  # ========
  def print_result_report
    @case = Case.find(params[:id])
    page_size = params[:page_size] || 'A5'

    begin
      case page_size
      when 'A5'
        printer = current_tenant.printer_for(:result_report_A5)
      when 'A4'
        printer = current_tenant.printer_for(:result_report_A4)
      end

      @case.print(page_size, printer)
      flash.now[:notice] = "#{@case} an Drucker gesendet"

    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end

  # P16/HPV
  # =======
  def hpv_p16_queue
    @cases = apply_scopes(Case).for_hpv_p16
    render 'index'
  end

  def hpv_p16_prepared
    @case = Case.find(params[:id])
    @case.hpv_p16_prepared_at = DateTime.now
    @case.hpv_p16_prepared_by = current_user.object
    @case.save
  end

  # Create a new HPV/P16 case after a case has been closed
  def create_hpv_p16_for_case
    @case = Case.find(params[:id])

    # Clone the case and set columns
    hpv = @case.clone
    hpv.praxistar_eingangsnr = CaseNr.new.to_s
    hpv.screened_at = nil
    hpv.delivered_at = nil
    hpv.finding_classes = []
    hpv.finding_text = ""

    hpv.needs_p16 = true
    hpv.needs_hpv = true
    hpv.classification = Classification.where("code = 'hpv' AND examination_method_id = #{hpv.examination_method_id}").first
    hpv.save

    redirect_to :controller => '/search'
  end

  def resend
    @case = Case.find(params[:id])
    @case.delivered_at = nil
    @case.save
  end

  # General
  # =======
  def show
    @case = Case.find(params[:id])

    respond_to do |format|
      format.html { }
      format.pdf {
        page_size = params[:page_size] || 'A5'
        document = @case.to_pdf(page_size)

        send_data document, :filename => "#{@case.id}.pdf",
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end
end
