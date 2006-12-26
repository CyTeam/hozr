require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/finding_classes_controller'

# Re-raise errors caught by the controller.
class Cyto::FindingClassesController; def rescue_action(e) raise e end; end

class Cyto::FindingClassesControllerTest < Test::Unit::TestCase
  fixtures :finding_classes

  def setup
    @controller = Cyto::FindingClassesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:finding_classes)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:finding_class)
    assert assigns(:finding_class).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:finding_class)
  end

  def test_create
    num_finding_classes = FindingClass.count

    post :create, :finding_class => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_finding_classes + 1, FindingClass.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:finding_class)
    assert assigns(:finding_class).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil FindingClass.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      FindingClass.find(1)
    }
  end
end
