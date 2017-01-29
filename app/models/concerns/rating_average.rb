module RatingAverage
    extend ActiveSupport::Concern
    def average_rating
        ratings.inject(0){ |sum, rating| sum + rating.score } / ratings.count.to_f
    end
end