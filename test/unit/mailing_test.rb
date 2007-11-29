require File.dirname(__FILE__) + '/../test_helper'

class MailingTest < Test::Unit::TestCase
  fixtures :mailings, 'cyto/cases'

  def test_create_all_for_doctor
    assert_equal 0, Mailing.count
    
    # Test doctor 1
    Mailing.create_all_for_doctor(1)
    assert_equal 1, Mailing.count
    
    # Test doctor 1, again
    m = Mailing.create_all_for_doctor(1)
    assert_equal 2, Mailing.count
    
    # Test without unprinted
    m.cases.map {|c|
      c.result_report_printed_at = Date.today
      c.save
    }
    Mailing.create_all_for_doctor(1)
    assert_equal 2, Mailing.count

    # Test doctor 2
    Mailing.create_all_for_doctor(2)
    assert_equal 3, Mailing.count
  end

  def test_create_all
    assert_equal 0, Mailing.count
    
    # Test all doctors
    Mailing.create_all
    assert_equal 2, Mailing.count

    # Test all doctors, again
    Mailing.create_all
    assert_equal 4, Mailing.count

    Mailing.find(:all).map {|m|
      m.cases.map {|c|
        c.result_report_printed_at = Date.today
        c.save
      }
    }

    # Test all doctors without unprinted
    Mailing.create_all
    assert_equal 4, Mailing.count
    
  end
end
