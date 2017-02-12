require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is not saved without a style" do
    beer = Beer.create name:"No Style"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  it "is is saved when name and style are proper" do
    beer = Beer.create name:"ProperName", style:"ProperStyle"
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  it "is is not saved when name is missing" do
    beer = Beer.create style:"Nameless"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
