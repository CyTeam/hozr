# encoding: UTF-8

class Case::LabelController < ApplicationController
  def new
    @next_day_nr = Case.where(:entry_date => Date.today).maximum(:intra_day_id).to_i + 1
  end

  def print
    case_labels = params[:case_label].select{|case_label| case_label[:date].present?}

    begin
      printer = current_tenant.printer_for(:barcode_label)

      case_labels.each do |case_label|
        LabelDocument.new.print(printer, Date.parse(case_label[:date]), case_label[:day_nr].to_i, case_label[:part_count].to_i)
      end

      flash.now[:notice] = "Barcodes für #{case_labels.count} Fälle an Drucker gesendet"

    rescue RuntimeError => e
      # Allow failing printer in demo env
      if !(Rails.env.demo? || Rails.env.development?)
        flash.now[:alert] = "Drucken fehlgeschlagen: #{e.message}.<br/>Keine Fälle erzeugt.".html_safe
        return
      end
    end

    case_labels.each do |case_label|
      entry_date = Date.parse(case_label[:date])
      code = '%s%03i' % [entry_date.strftime('%y%j'), case_label[:day_nr].to_i]

      Case.create(:praxistar_eingangsnr => code, :intra_day_id => case_label[:day_nr], :entry_date => entry_date)
    end
  end
end

