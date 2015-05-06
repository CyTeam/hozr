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
    render 'index'
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
    render 'index'
  end

  # Review Queue
  # ============
  def review_queue
    @cases = apply_scopes(Case).for_review
    render 'index'
  end

  def review_done
    @case = Case.find(params[:id])
    @case.review_done(current_user.object)

    if !@case.save(:context => :review_done)
      respond_to do |format|
        format.html do
          flash.now[:alert] = "Bitte Pflichtfelder ausfüllen."
          render 'second_entry_form' and return
        end
        format.js do
          flash.now[:alert] = "Fall nicht signiert, bitte alle Pflichtfelder ausfüllen."
          render 'show_flash' and return
        end
      end
    end

    # Persist as PDF
    @case.persist_pdf if current_tenant.settings['modules.result_report_archive']

    respond_to do |format|
      format.html do
        # Jump to next case when called from case view
        next_open = Case.for_review.where("praxistar_eingangsnr > ?", @case.praxistar_eingangsnr).first

        if next_open.nil?
          redirect_to root_path, :notice => "#{@case.to_s} signiert."
        else
          redirect_to next_open, :notice => "#{@case.to_s} signiert. Sie wurden zum nächsten zu signierenden Fall weitergeleitet."
        end
      end

      format.js {}
    end
  end

  def reactivate
    @case = Case.find(params[:id])
    @case.needs_review = true
    @case.review_at = nil
    @case.delivered_at = nil
    @case.save

    redirect_to @case
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
    hpv.praxistar_eingangsnr = CaseCode.new.to_s
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

    flash.now[:notice] = 'Fall wurde zum versenden vorgemerkt.'
    render 'show_flash'
  end

  def billing_queue
    @cases = apply_scopes(Case).for_billing
    render 'index'
  end

  def update_remarks
    @case = Case.find(params[:id])
    @case.update_attributes(params[:case])
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

        send_data document, :filename => @case.pdf_name,
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end

  def destroy
    destroy! { root_path }
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
end
