# encoding: UTF-8

class CaseListDocument < LetterDocument
  def initialize_fonts
    font 'Helvetica'
    font_size 8
  end

  attr_accessor :cases

  def to_pdf
    text "HPV/P16 Liste %s" % Time.now.strftime('%d.%m.%Y %H:%M'),
      :size => 12, :style => :bold

    # Table content creation.
    index = 0
    items = cases.map do |item|
      index += 1

      code = "%s (%s)" % [item.code, item.intra_day_id]
      patient = "%s, %s" % [item.patient.name, item.patient.birth_date]

      row = [
        "%i." % index,
        item.entry_date,
        code,
        patient,
        item.classification.to_s,
        item.doctor.vcard.abbreviated_name,
        item.screener.code
      ]
    end

    # Table creation.
    table items,
      :width => margin_box.width,
      :row_colors => ['ffffff', 'cccccc'],
      :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 8 } do

      # General cell styling
      cells.align  = :left
      cells.valign = :top
      cells.border_width = 0
      cells.padding = [5, 5, 5, 5]

      # Columns style
      column(3).font_style = :bold
    end

    render
  end
end
