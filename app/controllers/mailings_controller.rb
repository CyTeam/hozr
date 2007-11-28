class MailingsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # Show list of mailings
  def list
    @mailings = Mailing.find(:all, :order => 'created_at DESC', :limit => 50)
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
