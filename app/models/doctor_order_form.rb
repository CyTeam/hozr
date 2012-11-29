# encoding: utf-8

# Barcode
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

class DoctorOrderForm < Prawn::Document
  def initialize_fonts
    if @doctor.billing_doctor
      font "/usr/share/fonts/truetype/dustin/Domestic_Manners.ttf"
      font_size 10
    else
      font "/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf"
      font_size 9
    end
  end

  def default_options
    { :page_size => 'A5', :top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23 }
  end

  def initialize(doctor, opts = {})
    @doctor = doctor

    # Default options
    opts.reverse_merge!(default_options)

    super(opts)

    initialize_fonts
  end

  def to_pdf
    # define grid
    define_grid(:columns => 11, :rows => 16, :gutter => 2) #.show_all('EEEEEE')

    grid([1,7], [2,9]).bounding_box do
      text @doctor.praxis.honorific_prefix, :leading => 2.5
      text @doctor.praxis.given_name + " " + @doctor.praxis.family_name, :leading => 2.5
      text @doctor.praxis.street_address, :leading => 2.5
      text @doctor.praxis.postal_code + " " + @doctor.praxis.locality, :leading => 2.5
    end

    grid([1,11], [2,11]).bounding_box do
      barcode = Barby::Code39.new("%04d" % @doctor.id)
      rotate(90, :origin => [0,0]) do
        barcode.annotate_pdf(self, :height => 14, :xdim => 1, :ypos => 20)
      end
    end

    render
  end

  def print(printer_name)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.binmode
    file.puts(to_pdf)
    file.close

    printer = CupsPrinter.new(printer_name)

    printer.print_file(file.path)
  end
end
