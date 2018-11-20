require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
    assert_template 'sessions/new' # Je vérifie le template
    assert_login_path_when_not_logged # Et les différents liens présents
  end

end
