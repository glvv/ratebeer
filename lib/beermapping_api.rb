class BeermappingApi

  def self.places_in(city)
    Rails.cache.fetch(city, expires_in: 3600) { fetch_places_in(city) }
  end

  def self.recent_place(place_id, city)
    Rails.cache.read(city).find { |c| c.id == place_id }
  end

  private

  def self.fetch_places_in(city)
    url = 'http://stark-oasis-9187.herokuapp.com/api/'

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

end
