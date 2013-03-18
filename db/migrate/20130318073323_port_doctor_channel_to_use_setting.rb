class PortDoctorChannelToUseSetting < ActiveRecord::Migration
  def up
    Doctor.find_each do |doctor|
      doctor.settings[:result_report_channels] = doctor[:channels]
    end
  end
end
