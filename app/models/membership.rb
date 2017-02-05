class Membership < ActiveRecord::Base
  belongs_to :beerclub
  belongs_to :user
end
