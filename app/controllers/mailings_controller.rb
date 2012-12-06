# encoding: utf-8'
class MailingsController < ApplicationController
  authorize_resource

  has_scope :by_state

  def index
    @mailings = apply_scopes(Mailing).order('mailings.created_at DESC').limit(100)
  end

  def generate
    Mailing.create_all
    redirect_to mailings_path(:by_state => :unsent)
  end

  # Overview for mailing
  def overview
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

  def show
    overview

    render 'overview'
  end

  # Printing
  # ========
  def print_overview
    @mailing = Mailing.find(params[:id])

    printer = 'hpT2'
    @mailing.print_overview(printer)
    redirect_to :action => :show, :id => @mailing.id
  end

  def print_result_reports
    @mailing = Mailing.find(params[:id])

    page_size = params[:page_size] || 'A5'

    overview_printer = 'hpT2'
    case page_size
    when 'A5'
      printer = 'hpT3'
    when 'A4'
      printer = 'HP2840'
    end

    @mailing.print_result_reports(page_size, printer)

    redirect_to :action => :show, :id => @mailing.id
  end

  def print
    @mailing = Mailing.find(params[:id])

    page_size = params[:page_size] || 'A5'

    overview_printer = 'hpT2'
    case page_size
    when 'A5'
      printer = 'hpT3'
    when 'A4'
      printer = 'HP2840'
    end

    @mailing.print(page_size, overview_printer, printer)

    redirect_to :action => :show, :id => @mailing.id
  end

  def print_all
    print_queue = SendQueue.unsent.by_channel('print')

    begin
      output = ""
      for print_queue in print_queue
        print_queue.print
        output += print_queue.mailing.to_s + "<br/>"
      end

      flash.now[:notice] = output.html_safe
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
