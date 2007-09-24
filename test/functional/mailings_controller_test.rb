require File.dirname(__FILE__) + '/../test_helper'
require 'mailings_controller'

# Re-raise errors caught by the controller.
class MailingsController; def rescue_action(e) raise e end; end

class MailingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = MailingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
