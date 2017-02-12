require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is saved with a proper password" do
    user = FactoryGirl.create(:user)

    expect(user).to be_valid
    expect(User.count).to eq(1)
  end

  it "is not saved with password that is too short" do
    user = User.create username:"Pekka", password:"123", password_confirmation:"123"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with password consisting of only letters" do
    user = User.create username:"Pekka", password:"OnlyLetters", password_confirmation:"OnlyLetters"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with highest average rating if several rated" do
      ipa = FactoryGirl.create(:ipa)
      ipa2 = FactoryGirl.create(:ipa)
      bitter = FactoryGirl.create(:bitter)
      create_rating(user, ipa, 2)
      create_rating(user, ipa2, 4)
      create_rating(user, bitter, 1)
      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_brewery.name).to eq("anonymous")
    end

    it "is the one with highest average rating if several rated" do
      ipa = FactoryGirl.create(:ipa)
      ipa2 = FactoryGirl.create(:ipa)
      bitter = FactoryGirl.create(:bitter)
      create_rating(user, ipa, 2)
      create_rating(user, ipa2, 4)
      create_rating(user, bitter, 5)
      expect(user.favorite_brewery.name).to eq("Fire")
    end
  end

end

def create_rating(user, beer, score)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end
