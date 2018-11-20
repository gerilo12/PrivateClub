require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:foobar)
    @user2 = users(:barfoo)
  end

  test "should get new" do
    # On accède à l'écran signup sans problème
    get signup_path
    assert_response :success
  end

  test "should get index only if logged in" do
    # Si on est pas login => On trouve la page mais on est redirigé vers /login
    get users_path
    assert_response :found # Vérifie qu'on trouve la page
    follow_redirect!
    assert_template 'sessions/new' # Mais on est redirigé vers login

    # On simule un login
    get login_path
    post login_path, params: { session: { email: @user1.email,
                                          password: 'password' } }
    get users_path
    assert_response :success # Vérifie qu'on réussit à accèder à la page une fois login
  end

  test "should get show only if logged in" do
    # Si on est pas login => On trouve la page mais on est redirigé vers /login
    get user_path(@user1)
    assert_response :found # Vérifie qu'on trouve la page
    follow_redirect!
    assert_template 'sessions/new' # Mais on est redirigé vers login

    # On simule un login
    get login_path
    post login_path, params: { session: { email: @user1.email,
                                          password: 'password' } }
    get user_path(@user1)
    assert_response :success # Vérifie qu'on réussit à accèder à la page une fois login
    # Puis je vérifie que le profil montre bien les éléments qui m'intéresse
    assert_select 'h1', "#{@user1.first_name} #{@user1.last_name}" # Nom et prénom
    assert_select 'p', "Adresse Mail : #{@user1.email}" # Email
    assert_select "a[href=?]", edit_user_path(@user1) # Et un lien pour éditer le profil
  end

  test "should get edit only if logged" do
    # Si on est pas login => On trouve la page mais on est redirigé vers /login
    get edit_user_path(@user1)
    assert_response :found # Vérifie qu'on trouve la page
    follow_redirect!
    assert_template 'sessions/new' # Mais on est redirigé vers login

    # On simule un login
    get login_path
    post login_path, params: { session: { email: @user1.email,
                                          password: 'password' } }
    get edit_user_path(@user1)
    assert_response :success # Vérifie qu'on réussit à accèder à la page une fois login
  end

  test "should not get edit if not own account" do
    # On simule un login avec user 1
    get login_path
    post login_path, params: { session: { email: @user1.email,
                                          password: 'password' } }
    # On essaie d'éditer le profil du user 2
    get edit_user_path(@user2)
    assert_response :found # On trouve la page
    follow_redirect!
    assert_template 'static_pages/home' # Mais on est redirigé vers l'accueil
  end

end
