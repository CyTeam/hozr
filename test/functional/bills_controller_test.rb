require File.dirname(__FILE__) + '/../test_helper'
require 'bills_controller'

# Re-raise errors caught by the controller.
class BillsController; def rescue_action(e) raise e end; end

class BillsControllerTest < Test::Unit::TestCase
  def setup
    @controller = BillsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
