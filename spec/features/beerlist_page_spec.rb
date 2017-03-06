require 'rails_helper'

describe "Beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  def find_first_n_table_rows_and_expect_content(n, *content)
    (2..n+1).each do |i|
      expect(find('table').find('tr:nth-child(' + i.to_s + ')')).to have_content content[i-2]
    end
  end

  it "beers are initially shown alphabetically", :js => true do
    visit beerlist_path
    find_first_n_table_rows_and_expect_content(3, "Fastenbier", "Lechte Weisse", "Nikolai")
  end

  it "sorts the columns by style when clicking style", :js => true do
    visit beerlist_path
    click_link "Style"
    find_first_n_table_rows_and_expect_content(3, "Lager", "Rauchbier", "Weizen")
  end

  it "sorts the columns by brewery when clicking brewery", :js => true do
    visit beerlist_path
    click_link "Brewery"
    find_first_n_table_rows_and_expect_content(3, "Ayinger", "Koff", "Schlenkerla")
  end

end
