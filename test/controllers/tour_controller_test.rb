require 'test_helper'

class TourControllerTest < ActionController::TestCase
  test "should get tour" do
    get :search
    jsondata = assigns(:jsonData)
    assert_not_nil jsondata
    assert_not_nil jsondata['results']['tour'][0]['title']
    # assert_response :success
  end

end
