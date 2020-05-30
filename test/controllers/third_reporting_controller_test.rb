require 'test_helper'

class ThirdReportingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get third_reporting_index_url
    assert_response :success
  end

end
