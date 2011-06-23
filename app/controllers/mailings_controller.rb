class MailingsController < ApplicationController
  helper :cases
  
  def index
    list
    render :action => 'list'
  end

  # Show list of mailings
  def list
    @mailings = Mailing.find(:all, :order => 'mailings.created_at DESC', :limit => 100)
  end

  # Show list of unprinted mailings
  def list_open
    @mailings = Mailing.unsent
  end

  def generate
    Mailing.create_all
    redirect_to :action => 'list_open'
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
    when 'A5':
      printer = 'hpT3'
    when 'A4':
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
    when 'A5':
      printer = 'hpT3'
    when 'A4':
      printer = 'HP2840'
    end

    @mailing.print(page_size, overview_printer, printer)

    redirect_to :action => :show, :id => @mailing.id
  end

  def statistics
    @doctor = Doctor.find(params[:doctor_id])
    case_conditions = YAML.load(params[:case_conditions])
    
    count = Case.count(:conditions => case_conditions)
    Case.send('with_scope', :find => {:conditions => case_conditions }) do
      @records = Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code', :conditions => case_conditions)
      render :action => 'statistics'
    end
  end

  def statistics_for_pdf
    @doctor = Doctor.find(params[:doctor_id])
    case_conditions = YAML.load(params[:case_conditions])
    
    count = Case.count(:conditions => case_conditions)
    Case.send('with_scope', :find => {:conditions => case_conditions }) do
      @records = Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code', :conditions => case_conditions)
      render :action => 'statistics', :layout => 'stats_letter_for_pdf'
    end
  end

  def print_all
    print_queue = SendQueue.unsent.by_channel('print')
    
    output = ""
    for print_queue in print_queue
      print_queue.print
      output += print_queue.mailing.to_s + "<br/>"
    end

    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end
  
  # Multi Channel
  def send_by
    @mailing = Mailing.find(params[:id])
    @state = @mailing.send_by(params[:channel])
    
    render :partial => 'sent_by', :layout => false
  end

  def send_by_all_channels
    @mailing = Mailing.find(params[:id])
    @state = @mailing.send_by_all_channels
    
    render :partial => 'sent_by', :layout => false
  end
  
  def send_all
    @mailings = Mailing.unsent
    for mailing in @mailings
      mailing.send_by_all_channels
    end
    
    redirect_to :action => 'list_open'
  end
end
