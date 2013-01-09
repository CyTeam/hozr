require 'prawn/measurement_extensions'

# Barcode
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'

class LabelDocument < Prawn::Document
  def default_options
    {
      :page_size => [12.mm, 23.mm],
      :top_margin => 0.mm,
      :bottom_margin => 0.mm,
      :left_margin => 0.mm,
      :right_margin => 3.mm
    }
  end

  def part_label(part_nr)
    code = '%s%03i%02i' % [@date.strftime('%y%j'), @day_nr, part_nr]
    text_code = '%s %03i/%02i' % [@date.strftime('%d.%m.%y'), @day_nr, part_nr]

    barcode = Barby::Code128C.new(code)
    rotate(90, :origin => [0,0]) do
      barcode.annotate_pdf(self, :unbleed => 0.1, :height => 35, :xdim => 0.6, :y => -20, :x => 4)

      font_size 6
      draw_text text_code, :at => [10, -26]
    end
  end

  def form_label
    code = '%s%03i' % [@date.strftime('%y%j'), @day_nr]
    text_code = '%s %03i/%02i-%02i' % [@date.strftime('%d.%m.%y'), @day_nr, 1, @part_count]

    barcode = Barby::Code128C.new(code)
    rotate(90, :origin => [0,0]) do
      barcode.annotate_pdf(self, :unbleed => 0.1, :height => 35, :xdim => 1, :y => -20, :x => 4)

      font_size 6
      draw_text text_code, :at => [10, -26]
    end
  end

  def to_pdf(date, day_nr, part_count)
    @date = date
    @day_nr = day_nr
    @part_count = part_count

    (1..part_count).each do |i|
      part_label(i)
      start_new_page unless i == part_count
    end

    start_new_page :size => [12.mm, 28.mm]
    form_label

    render
  end

  def initialize
    super default_options
  end

  def print(printer, *args)
    # Workaround TransientJob not yet accepting options
    file = Tempfile.new('')
    file.binmode
    file.puts(to_pdf(*args))
    file.close

    printer.print_file(file.path)
  end
end

