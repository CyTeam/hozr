# encoding: utf-8'
class MailingsController < AuthorizedController
  has_scope :by_state

  def index
    @mailings = apply_scopes(Mailing).order('mailings.created_at DESC').limit(100)
  end

  def generate
    Mailing.create_all
    redirect_to mailings_path(:by_state => :unsent)
  end

  # Overview for mailing
  def show
    @mailing = Mailing.find(params[:id])

    @doctor = @mailing.doctor
    @cases = @mailing.cases

    respond_to do |format|
      format.html {}
      format.pdf {
        document = @mailing.overview_to_pdf

        send_data document, :filename => "#{@mailing.id}.pdf",
                            :type => "application/pdf",
                            :disposition => 'inline'
      }
    end
  end

  # Printing
  # ========
  def print_overview
    @mailing = Mailing.find(params[:id])

    begin
      printer = current_tenant.printer_for(:mailing_overview)
      @mailing.print_overview(printer)

      flash.now[:notice] = "#{@mailing} an Drucker gesendet"

    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end

  def print_result_reports
    @mailing = Mailing.find(params[:id])

    page_size = params[:page_size] || current_tenant.settings['format.result_report']

    begin
      case page_size
      when 'A5'
        printer = current_tenant.printer_for(:result_report_A5)
      when 'A4'
        printer = current_tenant.printer_for(:result_report_A4)
      end

      @mailing.print_result_reports(page_size, printer)
      flash.now[:notice] = "#{@mailing} an Drucker gesendet"

    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end

  def print
    @mailing = Mailing.find(params[:id])

    page_size = params[:page_size] || current_tenant.settings['format.result_report']

    begin
      overview_printer = current_tenant.printer_for(:mailing_overview)
      case page_size
      when 'A5'
        printer = current_tenant.printer_for(:result_report_A5)
      when 'A4'
        printer = current_tenant.printer_for(:result_report_A4)
      end

      @mailing.print(page_size, overview_printer, printer)
      flash.now[:notice] = "#{@mailing} an Drucker gesendet"

    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end

  # Multi Channel
  def send_by
    @mailing = Mailing.find(params[:id])
    @send_queue = @mailing.send_by(params[:channel])

    if @send_queue.nil?
      flash.now[:alert] = "Bereits zum Versand vorgemerkt."
      render 'show_flash'
    end
  end

  def send_by_all_channels
    @mailing = Mailing.find(params[:id])
    @state = @mailing.send_by_all_channels

    render 'send_by_all_channels'
  end

  def send_all
    @mailings = Mailing.without_channel
    for mailing in @mailings
      mailing.send_by_all_channels
    end

    redirect_to mailings_path
  end
end
