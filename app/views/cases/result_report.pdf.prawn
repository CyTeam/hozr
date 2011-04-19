pdf.font_families.update(
  "Cholla Sans" => { :bold        => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanBol.ttf",
                     :bold_italic => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanBolIta.tff",
                     :normal      => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanReg.ttf",
                     :italic      => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanIta.ttf",
                     :thin        => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanThi.ttf",
                     :thin_italic => "#{RAILS_ROOT}/data/fonts/cholla/ChollSanThiIta.tff" })

# support page sizes
case pdf.page.size
when 'A4':
  pdf.font "Cholla Sans", :size => 13
when 'A5':
  pdf.font "Cholla Sans", :size => 10
else
  pdf.font "Cholla Sans"
end

# define grid
pdf.define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

#Header start
pdf.grid([0,1], [1,4]).bounding_box do
  pdf.text [patient_birth_date, patient_nr].compact.join(" / ")
  pdf.text @case.patient.vcard.full_name
  pdf.text @case.patient.vcard.street_address
  pdf.text @case.patient.vcard.postal_code + " " + @case.patient.vcard.locality
end

pdf.grid([0,7], [1,9]).bounding_box do
  pdf.text @case.doctor.praxis.honorific_prefix
  pdf.text @case.doctor.praxis.full_name
  pdf.text @case.doctor.praxis.street_address
  pdf.text @case.doctor.praxis.postal_code + " " + @case.doctor.praxis.locality
end

pdf.font "Cholla Sans", :style => :thin do
  pdf.grid([2,1], [2,4]).bounding_box do
    pdf.text insurance_policy
  end

  pdf.grid([2,7], [2,8]).bounding_box do
    pdf.text "Entnahme vom:"
    pdf.text "Eingang am:"
  end

  pdf.grid([2,9], [2,10]).bounding_box do
    pdf.text @case.examination_date ? @case.examination_date.strftime("%d.%m.%Y") : ""
    pdf.text @case.entry_date ? @case.entry_date.strftime("%d.%m.%Y") : ""
  end
end

pdf.grid([3,1], [3,9]).bounding_box do
  pdf.font "Cholla Sans", :style => :bold do
    pdf.text "Ihr Auftrag Nr. #{@case.praxistar_eingangsnr}"
  end
end

pdf.grid([4,1], [8,9]).bounding_box do
  begin
    pdf.image @case.order_form.file('result_remarks'), :width => pdf.bounds.width
  rescue
    pdf.text "Kein Scan Ihrer Kommentare vorhanden"
  end
end

pdf.grid([9,1], [9,9]).bounding_box do
  pdf.bounding_box pdf.bounds.top_left, :width => pdf.bounds.width, :height => 1.5 * pdf.font_size do
    pdf.fill_color @case.classification.classification_group.print_color
    pdf.fill_and_stroke_rectangle [0, pdf.font_size * 0.5], pdf.bounds.width, pdf.bounds.height
    pdf.fill_color '000000'

    pdf.font "Cholla Sans", :style => :bold do
      pdf.bounding_box [pdf.font_size * 0.25, pdf.font_size * 0.25], :width => pdf.bounds.width - 0.5 * pdf.font_size do
        pdf.text @case.classification.name
      end
    end
  end
end

pdf.grid([10,1], [12,4]).bounding_box do
  pdf.font "Cholla Sans", :style => :thin do
    if @case.finding_text.nil?
      for finding in @case.findings
        pdf.text finding.name
      end
    else
      # TODO: test if html formatting works
      pdf.text @case.finding_text.html_unescape
    end
  end
end

pdf.grid([10,6], [10,9]).bounding_box do
  pdf.font "Cholla Sans", :style => :bold do
    for finding in @case.control_findings
      pdf.text finding.name
    end
  end
end

pdf.grid([11,6], [11,9]).bounding_box do
  pdf.font "Cholla Sans", :style => :italic do
    for finding in @case.quality_findings
      pdf.text finding.name
    end
  end
end

if @case.screened_by and @case.screened_at
  pdf.grid(12, 6).bounding_box do
    pdf.text "Visum:"
  end

  pdf.grid([12,7], [12,9]).bounding_box do
    pdf.text @case.screened_by.work_vcard.abbreviated_name + ", " + @case.screened_at.strftime("%d.%m.%Y")
  end
end

if @case.review_by and @case.review_at
  pdf.grid(13, 6).bounding_box do
    pdf.text "Visum:"
  end

  pdf.grid([13,7], [13,9]).bounding_box do
    pdf.text @case.review_by.work_vcard.abbreviated_name + ", " + @case.review_at.strftime("%d.%m.%Y")
  end
end
