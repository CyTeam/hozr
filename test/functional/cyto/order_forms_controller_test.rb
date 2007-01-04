require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/order_forms_controller'

# Re-raise errors caught by the controller.
class Cyto::OrderFormsController; def rescue_action(e) raise e end; end

class Cyto::OrderFormsControllerTest < Test::Unit::TestCase
  fixtures :order_forms

  def setup
    @controller = Cyto::OrderFormsController.new
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

    assert_not_nil assigns(:order_forms)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:order_form)
    assert assigns(:order_form).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:order_form)
  end

  def test_create
    num_order_forms = OrderForm.count

    post :create, :order_form => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_order_forms + 1, OrderForm.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:order_form)
    assert assigns(:order_form).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil OrderForm.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      OrderForm.find(1)
    }
  end
end
