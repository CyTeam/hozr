require File.dirname(__FILE__) + '/../../test_helper'

class Cyto::CaseNrTest < Test::Unit::TestCase
  fixtures "cyto/cases"

  def test_new
    c = Cyto::CaseNr.new
    assert_equal c.to_s, '07/00001'

    c = Cyto::CaseNr.new(5)
    assert_equal c.to_s, '07/00005'

    c = Cyto::CaseNr.new(8, 5)
    assert_equal c.to_s, '08/00005'

    c = Cyto::CaseNr.new('08/00006')
    assert_equal c.to_s, '08/00006'

    c = Cyto::CaseNr.new('8/7')
    assert_equal c.to_s, '08/00007'

    c = Cyto::CaseNr.new(:year => 8, :nr => 8)
    assert_equal c.to_s, '08/00008'
  end

  def test_new_without_cases
    Cyto::Case.destroy_all
    c = Cyto::CaseNr.new
    
    assert_equal "#{Date.today.strftime('%y')}/00001", c.to_s
  end

  def test_next_case
    c = Cyto::Case.new
    c.praxistar_eingangsnr = '09/11111'
    c.save
    
    n = Cyto::CaseNr.new
    assert_equal '09/11112', n.to_s
  end
end
