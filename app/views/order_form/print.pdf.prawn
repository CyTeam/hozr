require 'barby/outputter/prawn_outputter'

if @doctor.billing_doctor
  pdf.font "/usr/share/fonts/truetype/dustin/Domestic_Manners.ttf"
  pdf.font_size 10
else
  pdf.font "/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf"
  pdf.font_size 9
end

# define grid
pdf.define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

pdf.grid([1,7], [2,9]).bounding_box do
  pdf.text @doctor.praxis.honorific_prefix, :leading => 2.5
  pdf.text @doctor.praxis.given_name + " " + @doctor.praxis.family_name, :leading => 2.5
  pdf.text @doctor.praxis.street_address, :leading => 2.5
  pdf.text @doctor.praxis.postal_code + " " + @doctor.praxis.locality, :leading => 2.5
end

pdf.grid([1,11], [2,11]).bounding_box do
  barcode = Barby::Code39.new("%04d" % @doctor.id)
  pdf.rotate(90, :origin => [0,0]) do
    barcode.annotate_pdf(pdf, :height => 14, :xdim => 1)
  end
end
