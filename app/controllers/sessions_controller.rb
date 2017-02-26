class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by username: params[:username]
    authenticated = user && user.authenticate(params[:password])
    if authenticated && user.blocked
      redirect_to :back, notice: "this account is frozen, please contact an administrator"
    elsif authenticated
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
