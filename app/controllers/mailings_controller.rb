class MailingsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # Show list of mailings
  def list
    @mailings = Mailing.find(:all, :order => 'created_at DESC', :limit => 50)
  end

  # Show list of unprinted mailings
  def list_open
    @mailings = Mailing.find(:all, :order => 'created_at DESC', :conditions => 'printed_at IS NULL')
    render :action => :list
  end

  # Overview for mailing
  def overview
    @mailing = Mailing.find(params[:id])
    
    @doctor = @mailing.doctor
    @cases = @mailing.cases
  end

  def overview_for_pdf
    overview
    render :action => 'overview', :layout => 'stats_letter_for_pdf'
  end

  def statistics
    @doctor = Doctor.find(params[:doctor_id])
    case_conditions = YAML.load(params[:case_conditions])
    
    count = Cyto::Case.count(:conditions => case_conditions)
    Cyto::Case.with_scope(:find => {:conditions => case_conditions }) do
      @records = Cyto::Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code', :conditions => case_conditions)
      render :action => 'statistics'
    end
  end

  def statistics_for_pdf
    @doctor = Doctor.find(params[:doctor_id])
    case_conditions = YAML.load(params[:case_conditions])
    
    count = Cyto::Case.count(:conditions => case_conditions)
    Cyto::Case.with_scope(:find => {:conditions => case_conditions }) do
      @records = Cyto::Case.find( :all, :select => "classifications.name AS Pap, count(*) AS Anzahl, count(*)/#{count}*100.0 AS Prozent", :joins => 'LEFT JOIN classifications ON classification_id = classifications.id', :group => 'classifications.code', :conditions => case_conditions)
      render :action => 'statistics', :layout => 'stats_letter_for_pdf'
    end
  end

  def generate
    Mailing.create_all
    redirect_to :action => 'list_open'
  end
  
  def reactivate
    @mailing = Mailing.find(params[:id])
    @mailing.reactivate
    
    redirect_to :action => 'list'
  end

  def print
    @mailing = Mailing.find(params[:id])

    command = "/usr/local/bin/hozr_print_result_mailing.sh #{@mailing.id}"
    stream = open("|#{command}")
    output = stream.read
 
    send_data output, :type => 'text/html; charset=utf-8', :disposition => 'inline'
  end

  def print_all
    mailings = Mailing.find(:all, :conditions => "printed_at IS NULL")
    
    output = ""
    for mailing in mailings
      command = "/usr/local/bin/hozr_print_result_mailing.sh #{mailing.id}"
      stream = open("|#{command}")
      output += stream.read
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


#  def prepare
#  end
end
