# encoding: utf-8'
class SendQueuesController < ApplicationController
  has_scope :by_state

  def index
    @send_queues = apply_scopes(SendQueue).order('created_at DESC').limit(200).all
  end

  def print_all
    print_queue = SendQueue.unsent.by_channel('print')

    page_size = params[:page_size] || current_tenant.settings['format.result_report']

    begin
      overview_printer = current_tenant.printer_for(:mailing_overview)
      case page_size
      when 'A5'
        printer = current_tenant.printer_for(:result_report_A5)
      when 'A4'
        printer = current_tenant.printer_for(:result_report_A4)
      end


      output = ""
      for print_queue in print_queue
        print_queue.print(page_size, overview_printer, printer)
        output += print_queue.mailing.to_s + "<br/>"
      end

      flash.now[:notice] = output.html_safe
    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end

  # Actions
  ACTIONS = ['print', 'email', 'overview-email', 'hl7']

  def perform
    @send_queue = SendQueue.find(params[:id])

    # Guard
    unless ACTIONS.include? @send_queue.channel.to_s
      flash.now[:alert] = "Aktion #{@send_queue.channel.to_s} ist nicht unterstützt."
      render 'show_flash'
      return
    end

    send(@send_queue.channel)
  end

  def email
    flash.now[:notice] = "E-Mail versandt."
    @send_queue.email

    render 'show_flash'
  end

  def print
    @print_queue = SendQueue.find(params[:id])

    page_size = params[:page_size] || current_tenant.settings['format.result_report']

    begin
      overview_printer = current_tenant.printer_for(:mailing_overview)
      case page_size
      when 'A5'
        printer = current_tenant.printer_for(:result_report_A5)
      when 'A4'
        printer = current_tenant.printer_for(:result_report_A4)
      end

      @print_queue.print(page_size, overview_printer, printer)
      flash.now[:notice] = "#{@print_queue.mailing} an Drucker gesendet"

    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end
end
