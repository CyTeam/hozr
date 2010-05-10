require 'barby/outputter/prawn_outputter'

if @doctor.billing_doctor
  font = "/usr/share/fonts/truetype/dustin/Domestic_Manners.ttf"
else
  font = "/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf"
end

# define grid
pdf.define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

pdf.font font do
  pdf.grid([1,7], [2,9]).bounding_box do
    pdf.text @doctor.praxis.honorific_prefix
    pdf.text @doctor.praxis.full_name
    pdf.text @doctor.praxis.street_address
    pdf.text @doctor.praxis.postal_code + " " + @doctor.praxis.locality
  end

  pdf.grid([1,11], [2,11]).bounding_box do
    barcode = Barby::Code39.new("%04d" % @doctor.id)
    pdf.rotate(90, :origin => [0,0]) do
      barcode.annotate_pdf(pdf, :height => 10, :xdim => 0.85)
    end
  end
end
