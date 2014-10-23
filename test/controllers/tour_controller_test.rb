require 'test_helper'

class TourControllerTest < ActionController::TestCase
  test "should get tour" do
    get :search
    jsondata = assigns(:tours)
    assert_not_nil jsondata
    assert_not_nil jsondata[0]['title']
    # assert_response :success
  end

end
