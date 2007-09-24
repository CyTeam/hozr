class MailingsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # Show list of mailings.
  def list
    @mailings = Mailing.find(:all)
  end
end
