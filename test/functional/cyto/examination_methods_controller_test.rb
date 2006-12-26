require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/examination_methods_controller'

# Re-raise errors caught by the controller.
class Cyto::ExaminationMethodsController; def rescue_action(e) raise e end; end

class Cyto::ExaminationMethodsControllerTest < Test::Unit::TestCase
  fixtures :examination_methods

  def setup
    @controller = Cyto::ExaminationMethodsController.new
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

    assert_not_nil assigns(:examination_methods)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:examination_method)
    assert assigns(:examination_method).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:examination_method)
  end

  def test_create
    num_examination_methods = ExaminationMethod.count

    post :create, :examination_method => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_examination_methods + 1, ExaminationMethod.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:examination_method)
    assert assigns(:examination_method).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ExaminationMethod.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ExaminationMethod.find(1)
    }
  end
end
