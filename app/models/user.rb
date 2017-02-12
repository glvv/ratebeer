class User < ActiveRecord::Base
  include RatingAverage
  has_secure_password
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  validates_format_of :password, :with => /.*[A-Z].*[0-9].*/
  has_many :ratings, :dependent => :destroy
  has_many :beers, through: :ratings
  has_many :memberships, :dependent => :destroy
  has_many :beerclubs, through: :memberships
  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end
  def favorite_style
    return nil if ratings.empty?
    h = {}
    ratings_by_style = ratings.group_by {|rating| rating.beer.style }
    ratings_by_style.collect { |style, ratings| h[style] = ratings.inject(0){ |sum, rating| sum + rating.score } / ratings.count.to_f}
    h.max_by{|k,v| v}[0]
  end
  def favorite_brewery
    return nil if ratings.empty?
    h = {}
    ratings_by_style = ratings.group_by {|rating| rating.beer.brewery }
    ratings_by_style.collect { |style, ratings| h[style] = ratings.inject(0){ |sum, rating| sum + rating.score } / ratings.count.to_f}
    h.max_by{|k,v| v}[0]
  end

end
