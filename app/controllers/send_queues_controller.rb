# encoding: utf-8'
class SendQueuesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # Show list of mailings
  def list
    @send_queues = SendQueue.sent.order('created_at DESC').limit(200).all
  end

  # Show list of unprinted mailings
  def list_open
    @send_queues = SendQueue.unsent.order('created_at DESC').limit(100).all
  end

  def print_all
    @print_queues = SendQueue.unsent.by_channel('print')
    
    for print_queue in @print_queues
      print_queue.print
      
#      sleep(20)
    end
  end

  def print
    @print_queue = SendQueue.find(params[:id])
    
    @print_queue.print

    render 'print', :print_queue => @print_queue
  end
end
