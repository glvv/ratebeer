class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    name + " (" + brewery.name + ")"
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  validates :name, presence: true
  validates :style, presence: true
end
