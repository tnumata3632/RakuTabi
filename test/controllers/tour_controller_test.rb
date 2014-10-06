require 'test_helper'

class TourControllerTest < ActionController::TestCase
  test "should get tour" do
    get :tour
    assert_response :success
  end

end
