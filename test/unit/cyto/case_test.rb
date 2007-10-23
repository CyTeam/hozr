require File.dirname(__FILE__) + '/../../test_helper'

class Cyto::CaseTest < Test::Unit::TestCase
  fixtures "cyto/cases" 

  # Replace this with your real tests.
  def test_find
    c = Cyto::Case.find(1)
    assert c.id == 1
  end

  def test_new
    c = Cyto::Case.new
    c.save
    
    d = Cyto::Case.find(c.id)
    assert d == c
  end

  def test_one
    case_one = Cyto::Case.find(2)

    assert_equal case_one.praxistar_eingangsnr, '07/00000'
    assert_equal '07/00001', Cyto::CaseNr.new.to_s
  end

  def test_validations
    empty_case = Cyto::Case.find(1)
    
    assert !empty_case.ready_for_first_entry
    assert !empty_case.ready_for_second_entry
    assert !empty_case.ready_for_p16
    assert !empty_case.ready_for_result_report_printing

    case_one = Cyto::Case.find(2)
    
    assert !case_one.ready_for_first_entry
    assert !case_one.ready_for_second_entry
    assert !case_one.ready_for_p16
    assert !case_one.ready_for_result_report_printing

    empty_case.assigned_at = DateTime.now
    assert empty_case.ready_for_first_entry
    assert !empty_case.ready_for_second_entry
    assert !empty_case.ready_for_p16
    assert !empty_case.ready_for_result_report_printing
    
    empty_case.entry_date = DateTime.now
    assert !empty_case.ready_for_first_entry
    assert empty_case.ready_for_second_entry
    assert !empty_case.ready_for_p16
    assert !empty_case.ready_for_result_report_printing
    
    empty_case.screened_at = DateTime.now
    assert !empty_case.ready_for_first_entry
    assert !empty_case.ready_for_second_entry
    assert !empty_case.ready_for_p16
    assert empty_case.ready_for_result_report_printing
    
    empty_case.reload
    empty_case.needs_p16 = true
    empty_case.screened_at = nil

    empty_case.entry_date = DateTime.now
    assert !empty_case.ready_for_first_entry
    assert !empty_case.ready_for_second_entry
    assert empty_case.ready_for_p16
    assert !empty_case.ready_for_result_report_printing
    
    empty_case.screened_at = DateTime.now
    assert !empty_case.ready_for_first_entry
    assert !empty_case.ready_for_second_entry
    assert !empty_case.ready_for_p16
    assert empty_case.ready_for_result_report_printing
  end

  def test_examination_date
    c = Cyto::Case.find(1)
    now = Date.today

    c.examination_date = now
    assert_equal now.to_s, c.examination_date.to_s

    c.examination_date = '1.1.07'
    assert_equal '2007-01-01', c.examination_date.to_s
  end
end
