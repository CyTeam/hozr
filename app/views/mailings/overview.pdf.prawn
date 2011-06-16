require 'prawn/measurement_extensions'

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

# Address
pdf.grid([0,7], [1,9]).bounding_box do
  pdf.text @mailing.doctor.praxis.honorific_prefix
  pdf.text @mailing.doctor.praxis.full_name
  pdf.text @mailing.doctor.praxis.street_address
  pdf.text @mailing.doctor.praxis.postal_code + " " + @mailing.doctor.praxis.locality
end

# Place'n'Date
pdf.grid([2,7], [2,9]).bounding_box do
  pdf.text "Affoltern a. A., " + @mailing.created_at.strftime("%d.%m.%Y")
end

# Subject
pdf.grid([3,0], [3,9]).bounding_box do
  pdf.font "Cholla Sans", :style => :bold do
    pdf.text "Befundübersicht"
  end
end

# Table content creation.
items = @mailing.cases.map do |item|
  row = [
    pdf.make_cell(:content => item.patient.name),
    pdf.make_cell(:content => item.patient.birth_date),
    pdf.make_cell(:content => item.control_findings.map {|f| h(f.name)}.join("\n")),
    pdf.make_cell(:content => item.examination_date.strftime('%d.%m.%Y')),
    pdf.make_cell(:content => item.praxistar_eingangsnr)
  ]
end

# Table header creation.
headers = [[
  pdf.make_cell(:content => "PAP II <i>(#{items.count})</i>", :inline_format => true),
  "Geb.",
   "",
   "Entn.",
   "Eing.Nr."
]]

# Table creation.
pdf.table headers + items, :header => true,
                           :width => pdf.margin_box.width,
                           :cell_style => { :overflow => :shrink_to_fit, :min_font_size => 8 } do

  # General cell styling
  cells.align  = :left
  cells.valign = :top
  cells.border_width = 0
  cells.size = 10
  cells.padding = [0, 5, 0, 5]
  column(0).padding = [0, 5, 0, 0]
  column(-1).padding = [0, 0, 0, 5]

  # Headings styling
  row(0).font_style = :italic
  row(0).column(0).font_style = :bold
  row(0).padding = [0, 5, 3, 5]
  row(0).column(0).padding = [0, 5, 3, 0]
  row(0).column(-1).padding = [0, 0, 3, 5]

  # Columns width
  column(1).width = 1.8.cm
  column(3).width = 1.8.cm
  column(4).width = 1.8.cm

  # Columns align
  column(1).align = :right
  column(3).align = :right
  column(4).align = :right

  # Columns colors
  column(0).row(1..-1).text_color = '660000'
  column(4).row(1..-1).text_color = '660000'

  # Columns style
  column(0).font_style = :bold
  column(2).font_style = :bold
end
