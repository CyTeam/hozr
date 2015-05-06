# encoding: utf-8'

class Case::SecondEntryController < ApplicationController

  # Second Entry
  # ============
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

    @case.update_attributes(params[:case])

    context = :save
    case params[:button]
    when "queue_for_review"
      context = :sign
      if @case.valid?(context)
        @case.sign(current_user.object)
      end
    when "review_done"
      context = :review_done
      if @case.valid?(context)
        @case.sign(current_user.object)
        @case.review_done(current_user.object)
      end
    end

    if !@case.save(:context => context)
      flash.now[:alert] = "Bitte Pflichtfelder ausfüllen."
      render 'second_entry_form'
      return
    end

    # Jump to next case
    next_open = Case.first_entry_done.where("praxistar_eingangsnr > ?", @case.praxistar_eingangsnr).first
    if next_open.nil?
      redirect_to root_path, :notice => "#{@case.to_s} gespeichert."
    else
      redirect_to second_entry_form_case_path(next_open), :notice => "#{@case.to_s} gespeichert. Sie wurden zum nächsten Fall weitergeleitet."
    end
  end

  def sign
    @case = Case.find(params[:id])
    @case.sign(cuurent_user.object)
    @case.update_attributes(params[:case])

    # TODO: generalize
    # Check if case needs review
    if false
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
    end
    # END TODO

    if @case.needs_p16? or @case.needs_hpv?
      @case.delivered_at = nil
      @case.save

      redirect_to :action => 'hpv_p16_queue'
    else
      if !@case.save(:context => :sign)
        flash.now[:alert] = "Bitte Pflichtfelder ausfüllen."
        render 'second_entry_form'
        return
      end

      # Jump to next case
      next_open = Case.for_second_entry.where("praxistar_eingangsnr > ?", @case.praxistar_eingangsnr).first

      if next_open.nil?
        redirect_to root_path, :notice => "#{@case.to_s} zum Signieren vorgemerkt."
      else
        redirect_to second_entry_form_case_path(next_open), :notice => "#{@case.to_s} zum Signieren vorgemerkt. Sie wurden zum nächsten Fall weitergeleitet."
      end
    end
  end

  autocomplete :finding_class, [:code, :name], :column => '', :extra_data => [:name], :display_value => :to_s, :full => true

  def remove_finding
    @case = Case.find(params[:id])

    finding = FindingClass.find(params[:finding_id])
    @case.finding_classes.delete(finding)
    name = finding.name
    quoted_name = name.gsub('ä', '&auml;').gsub('ö', '&ouml;').gsub('ü', '&uuml;').gsub('Ä', '&Auml;').gsub('Ö', '&Ouml;').gsub('Ü', '&Uuml;')

    @case.finding_text = @case.finding_text.gsub(/<div>#{Regexp.escape(name)}<\/div>(\n)?/, '').gsub("<div>#{quoted_name}</div>", '')

    @case.save

    render 'finding_classes/list_findings'
  end

  def add_finding
    @case = Case.find(params[:id])

    begin
      if params[:finding_id]
        finding_class_id = params[:finding_id]
        finding_class = FindingClass.find(finding_class_id)
      elsif params[:finding_class][:selection] > ''
        finding_class_code = params[:finding_class][:selection].split(' - ')[0]
        finding_class = FindingClass.find_by_code(finding_class_code)
      elsif params[:finding_class][:code]
        finding_class_code = params[:finding_class][:code]
        finding_class = FindingClass.find_by_code(finding_class_code)
      end

      @case.finding_classes << finding_class
      finding_text = @case.finding_text.nil? ? '' : @case.finding_text
      @case.finding_text = finding_text + "<div>#{finding_class.name}</div>\n" if finding_class.finding_group.nil?

      @case.save

    rescue ActiveRecord::AssociationTypeMismatch
      flash.now[:error] = "Unbekannter Code: #{finding_class_code}"

    rescue ActiveRecord::StatementInvalid
      flash.now[:error] = "Code bereits eingegeben"
    end

    render 'finding_classes/list_findings'
  end

end
