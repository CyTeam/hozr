require "rails_helper"

describe 'cases/_result_report.html.haml', type: :view do
  let(:a_case) do
    stub_model(Case, :praxistar_eingangsnr => 'B12345')
  end

  it 'should render case title' do
    assign(:case, a_case)

    render

    expect(rendered).to match /B12345/
  end

  context 'with case_copy_tos' do
    it 'should work with case_copy_tos with no person' do
      a_case.case_copy_tos.build(:channels => ['email'], :person => nil)
      assign(:case, a_case)

      render
    end
  end
end
