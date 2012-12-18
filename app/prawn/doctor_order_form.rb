# encoding: utf-8

# Barcode
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

class DoctorOrderForm < LetterDocument
  def default_options
    { :page_size => 'A4', :top_margin => 35, :left_margin => 12, :right_margin => 12, :bottom_margin => 23 }
  end

  def initialize(doctor, opts = {})
    @doctor = doctor

    super opts
  end

  def to_pdf
    if @doctor
      bounding_box([310, 75], :width => 180) do
        text @doctor.praxis.honorific_prefix
        text @doctor.praxis.given_name + " " + @doctor.praxis.family_name
        text @doctor.praxis.street_address
        text @doctor.praxis.postal_code + " " + @doctor.praxis.locality
      end

      #grid([1,11], [2,11]).bounding_box do
        #barcode = Barby::Code39.new("%04d" % @doctor.id)
        #rotate(90, :origin => [0,0]) do
        #  barcode.annotate_pdf(self, :height => 14, :xdim => 1, :ypos => 20)
        #end
      #end
    end

    render
  end

  def print(printer, copies)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.binmode
    file.puts(to_pdf)
    file.close

    printer.print_file(file.path, {'copies' => copies})
  end
end
