# encoding: utf-8'
class SendQueuesController < ApplicationController
  has_scope :by_state

  def index
    @send_queues = apply_scopes(SendQueue).order('created_at DESC').limit(200).all
  end

  def print_all
    @print_queues = SendQueue.unsent.by_channel('print')
    
    begin
      for print_queue in @print_queues
        print_queue.print
      end
    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      render 'show_flash'
    end
  end

  def print
    @print_queue = SendQueue.find(params[:id])
    
    begin
      @print_queue.print

      render 'print', :print_queue => @print_queue
    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
      render 'show_flash'
    end
  end
end
