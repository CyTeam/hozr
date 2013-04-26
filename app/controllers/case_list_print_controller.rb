# encoding: utf-8

class CaseListPrintController < ApplicationController
  authorize_resource :class => false

  def print
    document = CaseListDocument.new
    document.cases = Case.for_hpv_p16

    begin
      printer = current_tenant.printer_for(:plain)

      document.print(printer)
      flash.now[:notice] = "#{@case} an Drucker gesendet"

    rescue RuntimeError => e
      flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}"
    end

    render 'show_flash'
  end
end
