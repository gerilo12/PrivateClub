class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:info] = "Tu es déja connecté !"
      redirect_to root_url
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "Bon retour, #{user.first_name} !"
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = "A bientôt !"
    redirect_to root_url
  end
end
