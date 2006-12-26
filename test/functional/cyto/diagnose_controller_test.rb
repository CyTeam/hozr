require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/diagnose_controller'

# Re-raise errors caught by the controller.
class Cyto::DiagnoseController; def rescue_action(e) raise e end; end

class Cyto::DiagnoseControllerTest < Test::Unit::TestCase
  def setup
    @controller = Cyto::DiagnoseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
