require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }
  let!(:style) { FactoryGirl.create :style }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is possible to add new beer with a valid name" do
    visit new_beer_path
    fill_in('beer_name', with:'Myrmidon')
    select('Lager', from:'beer_style_id')
    select(brewery.name, from:'beer_brewery_id')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
    expect(brewery.beers.count).to eq(1)
  end

  it "is not possible to add new beer with an invalid name" do
    visit new_beer_path
    select('Lager', from:'beer_style_id')
    select(brewery.name, from:'beer_brewery_id')
    expect{
      click_button "Create Beer"
    }.to_not change{Beer.count}
    expect(page).to have_content "Name can't be blank"
  end

end
