require 'rails_helper'

describe Doctor do
  context '#channels' do
    let(:doctor) { described_class.new }
    it 'returns empty array if result_report_channels config empty' do
      allow(doctor).to receive(:settings).and_return(:result_report_channels => '')
      expect(doctor.channels).to be_empty
    end

    it 'returns empty array if result_report_channels config nil' do
      allow(doctor).to receive(:settings).and_return(:result_report_channels => nil)
      expect(doctor.channels).to be_empty
    end

    it 'returns no nil channels' do
      allow(doctor).to receive(:settings).and_return(:result_report_channels => [nil, 'print', ''].to_yaml)
      expect(doctor.channels).to_not include(nil)
    end

    it 'returns no empty channels' do
      allow(doctor).to receive(:settings).and_return(:result_report_channels => [nil, 'print', ''].to_yaml)
      expect(doctor.channels).to_not include('')
    end

    it 'returns all channels' do
      allow(doctor).to receive(:settings).and_return(:result_report_channels => [nil, 'print', '', 'email'].to_yaml)
      expect(doctor.channels).to include('print')
      expect(doctor.channels).to include('email')
    end
  end
end
