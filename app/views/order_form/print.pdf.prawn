# define grid
pdf.define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

pdf.grid([1,7], [2,9]).bounding_box do
  pdf.text @doctor.praxis.honorific_prefix
  pdf.text @doctor.praxis.full_name
  pdf.text @doctor.praxis.street_address
  pdf.text @doctor.praxis.postal_code + " " + @doctor.praxis.locality
end
