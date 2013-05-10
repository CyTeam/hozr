# encoding: utf-8

module Zyto
  class ResultReport < Prawn::Document
    include CasesHelper
    include ApplicationHelper

    def default_options
      {
        :top_margin => 60, :left_margin => 35, :right_margin => 35, :bottom_margin => 23
      }
    end

    def initialize_fonts
    end

    def initialize(opts = {})
      # Default options
      opts.reverse_merge!(default_options)

      # Set the template
      letter_template = Attachment.for_class(self.class)
      opts.reverse_merge!(:template => letter_template.file.current_path) if letter_template

      super

      # Default Font
      initialize_fonts
    end

    def to_pdf(cases, to = nil)
      # We accept both a single case or an array
      @cases = cases.is_a?(Array) ? cases : [cases]

      font_path = Rails.root.join('data', 'fonts', 'cholla')
      font_families.update(
        "Cholla Sans" => { :bold        => font_path.join("ChollSanBol.ttf").to_s,
          :bold_italic => font_path.join("ChollSanBolIta.tff").to_s,
          :normal      => font_path.join("ChollSanReg.ttf").to_s,
          :italic      => font_path.join("ChollSanIta.ttf").to_s,
          :thin        => font_path.join("ChollSanThi.ttf").to_s,
          :thin_italic => font_path.join("ChollSanThiIta.tff").to_s
      })

      # support page sizes
      case page.size
      when 'A4'
        font "Cholla Sans", :size => 13
      when 'A5'
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
          text @case.doctor.vcard.honorific_prefix if @case.doctor.vcard.honorific_prefix
          text @case.doctor.vcard.full_name
          text @case.doctor.vcard.street_address
          text @case.doctor.vcard.postal_code + " " + @case.doctor.vcard.locality
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
                text finding.name, :inline_format => true
              end
            else
              # TODO: test if html formatting works
              text html_unescape(@case.finding_text), :inline_format => true
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
            text "Visum:" if @case.reviewer and @case.review_at
          end

          grid([12,7], [12,9]).bounding_box do
            text @case.screened_by.vcard.abbreviated_name + ", " + @case.screened_at.strftime("%d.%m.%Y")
            text @case.reviewer.vcard.abbreviated_name + ", " + @case.review_at.strftime("%d.%m.%Y") if @case.reviewer and @case.review_at
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
end
