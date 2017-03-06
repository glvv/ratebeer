class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin, only: [:toggle_blocked]

  def index
    @users = User.includes(:beers, :ratings).all
  end

  def new
    @user = User.new
  end

  def edit
  end

  def toggle_blocked
  user = User.find(params[:id])
  user.update_attribute :blocked, (not user.blocked)
  action = user.blocked? ? "frozen" : "unfrozen"
  redirect_to :back, notice:"account #{action}"
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
        if user_params[:username].nil? and @user == current_user and @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
    end
  end

  def destroy
    respond_to do |format|
      if current_user == @user
        @user.destroy
        session[:user_id] = nil
        # uudelleenohjataan sovellus pääsivulle
        format.html { redirect_to :root, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def show
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

end
