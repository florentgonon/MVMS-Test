require 'test_helper'

class SecondReportingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get second_reporting_index_url
    assert_response :success
  end

end
