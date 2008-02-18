require File.dirname(__FILE__) + '/../test_helper'
require 'delievery_returns_controller'

# Re-raise errors caught by the controller.
class DelieveryReturnsController; def rescue_action(e) raise e end; end

class DelieveryReturnsControllerTest < Test::Unit::TestCase
  def setup
    @controller = DelieveryReturnsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
