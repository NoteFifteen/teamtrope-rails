require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get high_allocations" do
    get :high_allocations
    assert_response :success
  end

end
