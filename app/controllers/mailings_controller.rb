class MailingsController < ApplicationController
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
    @mailings = Mailing.with_unsent_channel
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
  end
  
  def show
    overview
    
    render 'overview'
  end
  

  def overview_for_pdf
    overview
    render :action => 'overview', :layout => 'stats_letter_for_pdf'
  end

  def statistics
    @doctor = Doctor.find(params[:doctor_id])
    case_conditions = YAML.load(params[:case_conditions])
    
    count = Cyto::Case.count(:conditions => case_conditions)
    Cyto::Case.send('with_scope', :find => {:conditions => case_conditions }) do
      @records = Cyto::Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code', :conditions => case_conditions)
      render :action => 'statistics'
    end
  end

  def statistics_for_pdf
    @doctor = Doctor.find(params[:doctor_id])
    case_conditions = YAML.load(params[:case_conditions])
    
    count = Cyto::Case.count(:conditions => case_conditions)
    Cyto::Case.send('with_scope', :find => {:conditions => case_conditions }) do
      @records = Cyto::Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code', :conditions => case_conditions)
      render :action => 'statistics', :layout => 'stats_letter_for_pdf'
    end
  end

  def generate_overview_for_case_list
    case_ids = params[:ids].split('/')

    # Check if all cases belong to the same doctor
    cases = Cyto::Case.find(case_ids)
    doctor_ids = cases.map {|c| c.doctor_id}
    raise 'All cases in a mailing need to belong to same doctor' unless doctor_ids.uniq.size == 1

    mailing = Mailing.create(doctor_ids.first, case_ids)
    # TODO: printed_at is set to suppress printing with next result printing run, better use a flag
    mailing.printed_at = DateTime.now
    mailing.save
    
    redirect_to :action => 'overview', :id => mailing
  end

  def reactivate
    @mailing = Mailing.find(params[:id])
    @mailing.reactivate
    
    redirect_to :action => 'list'
  end

  def print
    @mailing = Mailing.find(params[:id])

    command = "/usr/local/bin/hozr_print_result_mailing.sh #{@mailing.id} '' #{( ENV['RAILS_ENV'] || 'development' )}"
    stream = open("|#{command}")
    output = stream.read
 
    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end

  def print_all
    mailings = Mailing.find(:all, :conditions => "printed_at IS NULL")
    
    output = ""
    for mailing in mailings.compact
      if mailing.doctor.wants_prints
        command = "/usr/local/bin/hozr_print_result_mailing.sh #{mailing.id} '' #{( ENV['RAILS_ENV'] || 'development' )}"
        stream = open("|#{command}")
        output += stream.read
      end
    end

    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end
  
  def print_overview
    @mailing = Mailing.find(params[:id])

    command = "/usr/local/bin/hozr_print_mailing_overview.sh #{@mailing.id}"
    stream = open("|#{command}")
    output = stream.read
 
    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end

  # Multi Channel
  def send_by
    @mailing = Mailing.find(params[:id])
    @mailing.send_by(params[:channel])
    
    render :partial => 'sent_by', :layout => false
  end
end
