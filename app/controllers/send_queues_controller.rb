class SendQueuesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # Show list of mailings
  def list
    @send_queues = SendQueue.sent.find(:all, :order => 'created_at DESC', :limit => 100)
  end

  # Show list of unprinted mailings
  def list_open
    @send_queues = SendQueue.unsent.find(:all, :order => 'created_at DESC', :limit => 100)
  end

  def print_all
    print_queues = SendQueue.unsent.by_channel('print')
    
    output = ""
    for print_queue in print_queues
      print_queue.print
      
#      sleep(20)
    end

    render :partial => 'send_queues/printed', :collection => print_queues
  end
end
