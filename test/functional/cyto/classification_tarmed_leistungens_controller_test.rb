require File.dirname(__FILE__) + '/../../test_helper'
require 'cyto/classification_tarmed_leistungens_controller'

# Re-raise errors caught by the controller.
class Cyto::ClassificationTarmedLeistungensController; def rescue_action(e) raise e end; end

class Cyto::ClassificationTarmedLeistungensControllerTest < Test::Unit::TestCase
  fixtures :classification_tarmed_leistungens

  def setup
    @controller = Cyto::ClassificationTarmedLeistungensController.new
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

    assert_not_nil assigns(:classification_tarmed_leistungens)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:classification_tarmed_leistungen)
    assert assigns(:classification_tarmed_leistungen).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:classification_tarmed_leistungen)
  end

  def test_create
    num_classification_tarmed_leistungens = ClassificationTarmedLeistungen.count

    post :create, :classification_tarmed_leistungen => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_classification_tarmed_leistungens + 1, ClassificationTarmedLeistungen.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:classification_tarmed_leistungen)
    assert assigns(:classification_tarmed_leistungen).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ClassificationTarmedLeistungen.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ClassificationTarmedLeistungen.find(1)
    }
  end
end
