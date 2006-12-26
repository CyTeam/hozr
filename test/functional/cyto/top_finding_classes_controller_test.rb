require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/top_finding_classes_controller'

# Re-raise errors caught by the controller.
class Cyto::TopFindingClassesController; def rescue_action(e) raise e end; end

class Cyto::TopFindingClassesControllerTest < Test::Unit::TestCase
  fixtures :top_finding_classes

  def setup
    @controller = Cyto::TopFindingClassesController.new
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

    assert_not_nil assigns(:top_finding_classes)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:top_finding_class)
    assert assigns(:top_finding_class).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:top_finding_class)
  end

  def test_create
    num_top_finding_classes = TopFindingClass.count

    post :create, :top_finding_class => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_top_finding_classes + 1, TopFindingClass.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:top_finding_class)
    assert assigns(:top_finding_class).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil TopFindingClass.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TopFindingClass.find(1)
    }
  end
end
