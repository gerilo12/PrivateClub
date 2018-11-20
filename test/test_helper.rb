ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns the full title on a per-page basis.
  # def full_title(page_title = '')
  #   base_title = 'StarrK Club'
  #
  #   if page_title.empty?
  #     base_title
  #   else
  #     page_title + ' | ' + base_title
  #   end
  # end

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  def assert_login_path_when_not_logged
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", signup_path, count: 2
  end

  def assert_signup_path
    assert_template 'users/new'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", signup_path, count: 1
  end

  def assert_users_path(user)
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,         count: 2
    assert_select "a[href=?]", user_path(user),         count: 1
    assert_select "a[href=?]", users_path,        count: 1
    assert_select "a[href=?]", logout_path,       count: 1
  end

  def assert_user_path(user)
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", users_path, count: 1
    assert_select "a[href=?]", user_path(user), count: 1
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
  end

  def assert_root_path_when_not_logged
    assert_select "a[href=?]", root_path,         count: 2
    assert_select "a[href=?]", login_path,        count: 1
    assert_select "a[href=?]", signup_path,       count: 2
    assert_select "a[href=?]", logout_path,       count: 0
    assert_select "a[href=?]", user_path(@user),  count: 0
  end

  def assert_root_path_when_logged(user)
    assert_select "a[href=?]", root_path,         count: 2
    assert_select "a[href=?]", user_path(user),   count: 1
    assert_select "a[href=?]", users_path,        count: 2
    assert_select "a[href=?]", login_path,        count: 0
    assert_select "a[href=?]", logout_path,       count: 1
  end
end
