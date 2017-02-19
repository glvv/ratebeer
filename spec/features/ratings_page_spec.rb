require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:brewery2) { FactoryGirl.create :brewery, name:"Partisan" }
  let!(:style1) { FactoryGirl.create :style, name:"Lager" }
  let!(:style2) { FactoryGirl.create :style, name:"Bitter" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:style1 }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery2, style:style2 }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")

  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "should show the correct number of ratings in the listing page" do
    create_ratings
    visit ratings_path
    expect(page).to have_content "Number of ratings: 2"
  end

  it "should show users ratings in the users page" do
    create_ratings
    visit user_path(user)
    expect(page).to have_content "has made 2 ratings"
    expect(page).to have_content "iso 3 10"
    expect(page).to have_content "Karhu 12"
  end

  it "should show users favorite brewery" do
    create_ratings
    visit user_path(user)
    expect(page).to have_content "Favorite brewery is Partisan"
  end

  it "should show users favorite style" do
    create_ratings
    visit user_path(user)
    expect(page).to have_content "Favorite style is Bitter"
  end

  it "should delete the rating" do
    create_ratings
    visit user_path(user)
    expect{
      first('li', :text => "Delete").click
    }.not_to change{user.ratings.count}
  end

end

def create_ratings
  FactoryGirl.create :rating, score: 10, beer: beer1, user: user
  FactoryGirl.create :rating, score: 12, beer: beer2, user: user
end
