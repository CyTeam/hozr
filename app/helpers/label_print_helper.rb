module LabelPrintHelper
  def label_select
    Case.for_second_entry.collect { |m| [ "#{m.praxistar_eingangsnr} (#{m.intra_day_id})", m.praxistar_eingangsnr ] }
  end
end
