require 'rails_helper'

describe "Places" do

  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several places are returned by the API, all of them are displayed" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Kylähullu", id: 2 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Kylähullu"
    expect(page).to have_content "Oljenkorsi"
  end

  it "if nothing is returned by the API, a notice is shown" do
    allow(BeermappingApi).to receive(:places_in).with("vallila").and_return(
      []
    )

    visit places_path
    fill_in('city', with: 'vallila')
    click_button "Search"

    expect(page).to have_content "No locations in vallila"
  end

end
