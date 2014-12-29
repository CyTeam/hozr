require "spec_helper"

describe Doctor do
  context "#channels" do
    let(:doctor) { Doctor.new }
    it "should return empty array if result_report_channels config empty" do
      allow(doctor).to receive(:settings).and_return({:result_report_channels => ""})
      expect(doctor.channels).to be_empty
    end

    it "should return empty array if result_report_channels config nil" do
      allow(doctor).to receive(:settings).and_return({:result_report_channels => nil})
      expect(doctor.channels).to be_empty
    end

    it "should return no nil channels" do
      allow(doctor).to receive(:settings).and_return({:result_report_channels => [nil, 'print', ''].to_yaml})
      expect(doctor.channels).to_not include(nil)
    end

    it "should return no empty channels" do
      allow(doctor).to receive(:settings).and_return({:result_report_channels => [nil, 'print', ''].to_yaml})
      expect(doctor.channels).to_not include('')
    end

    it "should return all channels" do
      allow(doctor).to receive(:settings).and_return({:result_report_channels => [nil, 'print', '', 'email'].to_yaml})
      expect(doctor.channels).to include('print')
      expect(doctor.channels).to include('email')
    end
  end
end
