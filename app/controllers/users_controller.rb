class UsersController < ApplicationController

  def show
    if logged_in?
      @user = User.find(params[:id])
    else
      flash[:danger] = "Bien essayé, petit malin !\nAccès restreint, connectes toi pour en voir plus."
      redirect_to login_url
    end
  end

  def index
    if logged_in?
      @users = User.all
    else
      flash[:danger] = "Bien essayé, petit malin !\nPour voir la liste des membres, tu dois te connecter."
      redirect_to login_url
    end
  end

  def new
    if logged_in?
      flash[:info] = "Tu es déja enregistré !"
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome in Dat Club !"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    if logged_in?
      if session[:user_id].to_i == params[:id].to_i
        @user = User.find(params[:id])
      else
        flash[:danger] = "Bien essayé, petit malin !\nCe n'est pas ton profil !"
        redirect_to root_url
      end
    else
      flash[:danger] = "Bien essayé, petit malin !\nAccès restreint, connectes toi pour en voir plus."
      redirect_to login_url
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:info] = "Profil mis à jour avec succès"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
