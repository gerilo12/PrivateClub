require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(first_name: "foo",
                     last_name: "bar",
                     email: "user@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  # Global

  test "sould be valid" do
    assert @user.valid?
  end

  # first_name

  test "first name should be present" do
    @user.first_name = "     "
    assert_not @user.valid?
  end

  test "first name should not be too long" do
    @user.first_name = 'a' * 51
    assert_not @user.valid?
  end

  test "first name should not be too short" do
    @user.first_name = 'aa'
    assert_not @user.valid?
  end

  # last_name

  test "last name should be present" do
    @user.last_name = "     "
    assert_not @user.valid?
  end

  test "last name should not be too long" do
    @user.last_name = 'a' * 51
    assert_not @user.valid?
  end

  test "last name should not be too short" do
    @user.last_name = 'aa'
    assert_not @user.valid?
  end



  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test "email validation should accept valid adresses" do
    valid_adresses = %w[user@example.com USER@foo.COM A_US-FR@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid?, "#{valid_adress.inspect} should be valid"
    end
  end

  test "email validation should reject invalid adresses" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.fr foo@bar+baz.com foo@bar..com]
    invalid_adresses.each do |invalid_adress|
      @user.email = invalid_adress
      assert_not @user.valid?, "#{invalid_adress} should be invalid"
    end
  end

  test "email adresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email adresses should be save in lowercase" do
    mixed_case_email = "fOo-BaR@bAz.OrG"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

end
