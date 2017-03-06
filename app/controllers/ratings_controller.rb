class RatingsController < ApplicationController
  before_action :skip_if_cached, only:[:index]
  
    def index
        @recent_ratings = Rating.recent(5)
        @best_beers = Beer.top(3)
        @best_breweries = Brewery.top(3)
        @best_styles = Style.top(3)
        @most_active_users = User.most_active_users(3)
    end

    def new
        @rating = Rating.new
        @beers = Beer.all
    end

    def create
        @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
        if current_user.nil?
             redirect_to signin_path, notice:'you should be signed in'
        end
        if @rating.save
          current_user.ratings << @rating
          session[:last_rating] = "#{@rating.beer.name} #{@rating.score} points"
          redirect_to user_path current_user
        else
          @beers = Beer.all
          render :new
        end
    end

    def destroy
        rating = Rating.find(params[:id])
        rating.delete if current_user == rating.user
        redirect_to :back
    end

    private

    def skip_if_cached
      @order = params[:order] || 'name'
      return render :index if request.format.html? and fragment_exist?( 'ratings_statistics' )
    end

end
