require File.dirname(__FILE__) + '/../test_helper'
require 'honorific_prefixes_controller'

# Re-raise errors caught by the controller.
class HonorificPrefixesController; def rescue_action(e) raise e end; end

class HonorificPrefixesControllerTest < Test::Unit::TestCase
  fixtures :honorific_prefixes

  def setup
    @controller = HonorificPrefixesController.new
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

    assert_not_nil assigns(:honorific_prefixes)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:honorific_prefix)
    assert assigns(:honorific_prefix).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:honorific_prefix)
  end

  def test_create
    num_honorific_prefixes = HonorificPrefix.count

    post :create, :honorific_prefix => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_honorific_prefixes + 1, HonorificPrefix.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:honorific_prefix)
    assert assigns(:honorific_prefix).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil HonorificPrefix.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      HonorificPrefix.find(1)
    }
  end
end
