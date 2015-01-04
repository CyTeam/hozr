require 'rails_helper'

describe Tenant do
  context '#settings' do
    let(:tenant) { described_class.new }
    it 'has proper defaults' do
      expect(tenant.settings['patients.sex']).to eql 'M'

      expect(tenant.settings['printing.cups']).to eql false

      expect(tenant.settings['format.result_report']).to eql 'A4'
      expect(tenant.settings['format.order_form']).to eql 'A4'

      expect(tenant.settings['mail.result_report.bcc']).to eql true
      expect(tenant.settings['mail.use_cylab']).to eql false

      expect(tenant.settings['modules.slidepath']).to eql false
      expect(tenant.settings['modules.p16']).to eql false
      expect(tenant.settings['modules.billing_queue']).to eql true
      expect(tenant.settings['modules.result_report_archive']).to eql false
    end
  end
end
