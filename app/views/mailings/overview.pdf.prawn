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
pdf.grid([3,1], [3,9]).bounding_box do
  pdf.font "Cholla Sans", :style => :bold do
    pdf.text "Befundübersicht"
  end
end

