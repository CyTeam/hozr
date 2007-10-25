require File.dirname(__FILE__) + '/../../test_helper'

class Cyto::CaseNrTest < Test::Unit::TestCase
  fixtures "cyto/cases"

  def test_new
    n = Cyto::CaseNr.new
    assert_equal "#{Date.today.strftime('%y')}/00001", n.to_s

    n = Cyto::CaseNr.new(5)
    assert_equal "#{Date.today.strftime('%y')}/00005", n.to_s

    n = Cyto::CaseNr.new(8, 5)
    assert_equal '08/00005', n.to_s

    n = Cyto::CaseNr.new('08/00006')
    assert_equal '08/00006', n.to_s

    n = Cyto::CaseNr.new('8/7')
    assert_equal '08/00007', n.to_s

    n = Cyto::CaseNr.new(:year => 8, :nr => 8)
    assert_equal '08/00008', n.to_s
  end

  def test_new_without_cases
    Cyto::Case.destroy_all
    n = Cyto::CaseNr.new
    
    assert_equal "#{Date.today.strftime('%y')}/00001", n.to_s
  end

  def test_next_case
    c = Cyto::Case.new
    c.praxistar_eingangsnr = '09/11111'
    c.save
    
    n = Cyto::CaseNr.new
    assert_equal '09/11112', n.to_s
  end

  def test_next_case_with_only_unassigned_cases
    Cyto::Case.destroy_all
    c = Cyto::Case.new
    c.save
    
    n = Cyto::CaseNr.new
    assert_equal "#{Date.today.strftime('%y')}/00001", n.to_s

    c = Cyto::Case.new
    c.praxistar_eingangsnr = ''
    c.save
    
    n = Cyto::CaseNr.new
    assert_equal "#{Date.today.strftime('%y')}/00001", n.to_s
  end
end
