require 'test_helper'

class BeerclubsControllerTest < ActionController::TestCase
  setup do
    @beerclub = beerclubs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beerclubs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beerclub" do
    assert_difference('Beerclub.count') do
      post :create, beerclub: { city: @beerclub.city, founded: @beerclub.founded, name: @beerclub.name }
    end

    assert_redirected_to beerclub_path(assigns(:beerclub))
  end

  test "should show beerclub" do
    get :show, id: @beerclub
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beerclub
    assert_response :success
  end

  test "should update beerclub" do
    patch :update, id: @beerclub, beerclub: { city: @beerclub.city, founded: @beerclub.founded, name: @beerclub.name }
    assert_redirected_to beerclub_path(assigns(:beerclub))
  end

  test "should destroy beerclub" do
    assert_difference('Beerclub.count', -1) do
      delete :destroy, id: @beerclub
    end

    assert_redirected_to beerclubs_path
  end
end
