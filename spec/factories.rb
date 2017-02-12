FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :rating do
    score 10
  end

  factory :rating2, class: Rating do
    score 20
  end

  factory :brewery do
    name "anonymous"
    year 1900
  end

  factory :beer do
    name "anonymous"
    brewery
    style "Lager"
  end

  factory :ipa, class: Beer do
    name "anonymous"
    brewery
    style "IPA"
  end

  factory :bitter, class: Beer do
    name "anonymous"
    association :brewery, factory: :brewery, name: "Fire", year: 1993
    style "Bitter"
  end

end
