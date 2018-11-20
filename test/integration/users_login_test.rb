require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foobar)
  end

  # Test un login invalide
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new' # Je vérifie le template
    assert_login_path_when_not_logged # Et les différents liens présents

    # On essaye de se connecter
    post login_path, params: { session: { email: "", password: "" } }
    assert_not is_logged_in? # On est pas connecté
    assert_template 'sessions/new' # Je vérifie que le template est le même
    assert_login_path_when_not_logged # Les différents liens présents
    assert flash.any? # Et qu'il y a bien un flash

    # Je retourne à l'accueil pour vérifier que le flash a disparu
    get root_path
    assert_template 'static_pages/home' # Je vérifie le template
    assert_root_path_when_not_logged # Et les différents liens présents
    assert flash.empty? # Le flash a disparu
  end

  # Test d'une connexion valide suivie d'une déconnexion
  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new' # Je vérifie le template
    assert_login_path_when_not_logged # Et les différents liens présents

    # On essaye de se connecter
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in? # Cette fois je suis bien connecté
    assert_redirected_to @user # On est bien redirigé sur la page du user
    follow_redirect!
    assert flash.any? # Et j'ai mon flash de bienvenue
    assert_template 'users/show' # Je vérifie que ma redirection m'a emmené sur le bon template
    assert_user_path(@user) # ET je check les liens présents sur la page en passant

    # Je retourne sur la page d'accueil
    get root_path
    assert flash.empty? # Le flash a bien disparu
    assert_template 'static_pages/home' # Je suis bien sur la page d'accueil
    assert_root_path_when_logged(@user) # Avec les liens qui vont bien quand on est connecté

    # Je simule la déconnection
    delete logout_path
    assert_not is_logged_in? # Est ce que je me suis bien déconnecté
    assert_redirected_to root_url # Et redirigé vers la page d'accueil
    follow_redirect!
    assert_template 'static_pages/home' # Je vérifie le template
    assert_root_path_when_not_logged # Et les liens présents quand on est pas connecté
    assert flash.any? # J'ai mon flash

    get root_path # J'actualise la page
    assert flash.empty? # Le flash a disparu
  end
end
