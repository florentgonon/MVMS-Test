require 'test_helper'

class FirstReportingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get first_reporting_index_url
    assert_response :success
  end

end
