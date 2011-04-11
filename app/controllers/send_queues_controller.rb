class SendQueuesController < ApplicationController
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
end
