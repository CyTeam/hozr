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
end
