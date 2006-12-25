require File.dirname(__FILE__) + '/../test_helper'
require 'doctors_controller'

# Re-raise errors caught by the controller.
class DoctorsController; def rescue_action(e) raise e end; end

class DoctorsControllerTest < Test::Unit::TestCase
  fixtures :doctors

  def setup
    @controller = DoctorsController.new
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

    assert_not_nil assigns(:doctors)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:doctor)
    assert assigns(:doctor).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:doctor)
  end

  def test_create
    num_doctors = Doctor.count

    post :create, :doctor => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_doctors + 1, Doctor.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:doctor)
    assert assigns(:doctor).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Doctor.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Doctor.find(1)
    }
  end
end
