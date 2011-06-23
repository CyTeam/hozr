class ResultReport < Prawn::Document
  include CasesHelper
  include ApplicationHelper
  
  def to_pdf(cases)
    # We accept both a single case or an array
    @cases = cases.is_a?(Array) ? cases : [cases]
  
    font_families.update(
      "Cholla Sans" => { :bold        => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanBol.ttf",
                         :bold_italic => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanBolIta.tff",
                         :normal      => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanReg.ttf",
                         :italic      => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanIta.ttf",
                         :thin        => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanThi.ttf",
                         :thin_italic => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanThiIta.tff" })

    # support page sizes
    case page.size
    when 'A4':
      font "Cholla Sans", :size => 13
    when 'A5':
      font "Cholla Sans", :size => 10
    else
      font "Cholla Sans"
    end

    for @case in @cases
    # define grid
    define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

    #Header start
    grid([0,1], [1,4]).bounding_box do
      text [patient_birth_date, patient_nr].compact.join(" / ")
      text @case.patient.vcard.full_name
      text @case.patient.vcard.extended_address if @case.patient.vcard.extended_address.present?
      text @case.patient.vcard.street_address
      text @case.patient.vcard.postal_code + " " + @case.patient.vcard.locality
    end

    grid([0,7], [1,9]).bounding_box do
      text @case.doctor.praxis.honorific_prefix
      text @case.doctor.praxis.full_name
      text @case.doctor.praxis.street_address
      text @case.doctor.praxis.postal_code + " " + @case.doctor.praxis.locality
    end

    font "Cholla Sans", :style => :thin do
      grid([2,1], [2,4]).bounding_box do
        text insurance_policy
      end

      grid([2,7], [2,8]).bounding_box do
        text "Entnahme vom:"
        text "Eingang am:"
      end

      grid([2,9], [2,10]).bounding_box do
        text @case.examination_date ? @case.examination_date.strftime("%d.%m.%Y") : ""
        text @case.entry_date ? @case.entry_date.strftime("%d.%m.%Y") : ""
      end
    end

    grid([3,1], [3,9]).bounding_box do
      font "Cholla Sans", :style => :bold do
        text "Ihr Auftrag Nr. #{@case.praxistar_eingangsnr}"
      end
    end

    grid([4,1], [8,9]).bounding_box do
      begin
        image @case.order_form.file('result_remarks'), :width => bounds.width
      rescue
        text "Kein Scan Ihrer Kommentare vorhanden"
      end
    end

    grid([9,1], [9,9]).bounding_box do
      bounding_box bounds.top_left, :width => bounds.width, :height => 1.5 * font_size do
        fill_color @case.classification.classification_group.print_color
        fill_and_stroke_rectangle [0, font_size * 0.5], bounds.width, bounds.height
        fill_color '000000'

        font "Cholla Sans", :style => :bold do
          bounding_box [font_size * 0.25, font_size * 0.25], :width => bounds.width - 0.5 * font_size do
            text @case.classification.name
          end
        end
      end
    end

    grid([10,1], [12,4]).bounding_box do
      font "Cholla Sans", :style => :thin do
        if @case.finding_text.nil?
          for finding in @case.findings
            text finding.name
          end
        else
          # TODO: test if html formatting works
          text html_unescape(@case.finding_text)
        end
      end
    end

    grid([10,6], [10,9]).bounding_box do
      font "Cholla Sans", :style => :bold do
        for finding in @case.control_findings
          text finding.name
        end
      end
    end

    grid([11,6], [11,9]).bounding_box do
      font "Cholla Sans", :style => :italic do
        for finding in @case.quality_findings
          text finding.name
        end
      end
    end

    if @case.screened_by and @case.screened_at
      grid(12, 6).bounding_box do
        text "Visum:"
      end

      grid([12,7], [12,9]).bounding_box do
        text @case.screened_by.work_vcard.abbreviated_name + ", " + @case.screened_at.strftime("%d.%m.%Y")
      end
    end

    if @case.review_by and @case.review_at
      grid(13, 6).bounding_box do
        text "Visum:"
      end

      grid([13,7], [13,9]).bounding_box do
        text @case.review_by.work_vcard.abbreviated_name + ", " + @case.review_at.strftime("%d.%m.%Y")
      end
    end

    if page.size == 'A5'
      grid([13,0], [15,4]).bounding_box do
        font "Cholla Sans", :size => 12 do
          move_down(10)
          text @case.patient.vcard.full_name
          text @case.patient.vcard.extended_address if @case.patient.vcard.extended_address.present?
          text @case.patient.vcard.street_address
          text @case.patient.vcard.postal_code + " " + @case.patient.vcard.locality
        end
      end

      grid([13,5], [15,7]).bounding_box do
        indent(10) do
          move_down(10)
          text [patient_birth_date, patient_nr].compact.join(" / ")
          text @case.patient.vcard.full_name
          text @case.patient.vcard.extended_address if @case.patient.vcard.extended_address.present?
          text @case.patient.vcard.street_address
          text @case.patient.vcard.postal_code + " " + @case.patient.vcard.locality
          text " "
          text @case.patient.insurance.vcard.full_name if @case.patient.insurance
        end
      end

      grid([13,8], [15,10]).bounding_box do
        indent(10) do
          move_down(10)
          text [patient_birth_date, patient_nr].compact.join(" / ")
          text @case.patient.vcard.full_name
          text @case.patient.vcard.extended_address if @case.patient.vcard.extended_address.present?
          text @case.patient.vcard.street_address
          text @case.patient.vcard.postal_code + " " + @case.patient.vcard.locality
          text " "
          text @case.patient.insurance.vcard.full_name if @case.patient.insurance
        end
      end
    end

    start_new_page unless @case == @cases.last
    end
    
    render
  end
end
