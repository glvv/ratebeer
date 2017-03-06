json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year, :active
  json.beers brewery.beers, :id, :name
end
