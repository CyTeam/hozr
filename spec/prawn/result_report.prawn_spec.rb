require "spec_helper"

describe ResultReport do
  let(:a_case) do
    stub_model(Case, :praxistar_eingangsnr => '123456')
  end

  it 'should render case title' do
    ResultReport.new().to_pdf(a_case)
  end

  context 'with case_copy_tos' do
    it 'should work with case_copy_tos with no person' do
      a_case.case_copy_tos.build(:channels => ['email'], :person => nil)
      ResultReport.new().to_pdf(a_case)
    end
  end
end

