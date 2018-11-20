require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path # Je vais sur la page signup
    assert_signup_path # Je check le template et les liens
    # Puis je simule le signup d'un utilisateur
    # Je vérifie le nb d'user en db avant et après la simulation
    # Si il n'y a pas de différence => Le user ne s'est pas créé
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { first_name:  "",
                                          last_name: "",
                                          email: "user@invalid",
                                          password:              "foo",
                                          password_confirmation: "bar" } }
    end
    assert_template 'users/new' # Je vérifie que je suis toujours sur la page signup
    # Les messages d'erreurs affichés n'étant pas des flashs, je ne les teste pas ici
  end

  test "valid signup information" do
    get signup_path # Je vais sur la page signup
    assert_signup_path # Je check le template et les liens
    # Puis je simule le signup d'un utilisateur
    # Je vérifie le nb d'user en db avant et après la simulation
    # Si il y a une différence de 1 => Le user a bien été créé
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { first_name:  "Foo",
                                          last_name: "Bar",
                                          email: "foobar@example.com",
                                          password:              "password",
                                          password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show' # Et j'arrive bien sur la page du user
    assert flash.any? # Avec un flash de bienvenue
    assert is_logged_in? # Et je suis connecté sur le site
  end

end
