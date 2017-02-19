class PlacesController < ApplicationController

  def index
  end

  def search
    city = params[:city].downcase
    @places = BeermappingApi.places_in(city)
    session[:last_city_searched] = city
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
    place_id = params[:id]
    city = session[:last_city_searched]
    @place = BeermappingApi.recent_place(place_id, city)
  end

end
