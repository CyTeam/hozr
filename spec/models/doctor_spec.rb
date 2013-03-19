require "spec_helper"

describe Doctor do
  context "#channels" do
    let(:doctor) { Doctor.new }
    it "should return empty array if result_report_channels config empty" do
      doctor.stub(:settings => {:result_report_channels => ""})
      doctor.channels.should == []
    end

    it "should return empty array if result_report_channels config nil" do
      doctor.stub(:settings => {:result_report_channels => nil})
      doctor.channels.should == []
    end

    it "should return no nil channels" do
      doctor.stub(:settings => {:result_report_channels => [nil, 'print', ''].to_yaml})
      doctor.channels.should_not include(nil)
    end

    it "should return no empty channels" do
      doctor.stub(:settings => {:result_report_channels => [nil, 'print', ''].to_yaml})
      doctor.channels.should_not include('')
    end

    it "should return all channels" do
      doctor.stub(:settings => {:result_report_channels => [nil, 'print', '', 'email'].to_yaml})
      doctor.channels.should include('print')
      doctor.channels.should include('email')
    end
  end
end
