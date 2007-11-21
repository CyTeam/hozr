require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/classification_groups_controller'

# Re-raise errors caught by the controller.
class Cyto::ClassificationGroupsController; def rescue_action(e) raise e end; end

class Cyto::ClassificationGroupsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Cyto::ClassificationGroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
