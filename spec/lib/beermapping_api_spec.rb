require 'rails_helper'

describe "BeermappingApi" do
  it "when HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Gallows Bird")
    expect(place.street).to eq("Merituulentie 30")
  end

  it "when HTTP GET returns no entries, an empty array is returned" do

    canned_answer = <<-END_OF_STRING
    <?xml version="1.0" encoding="UTF-8"?>
    <bmp-locations>
      <location>
        <id nil="true"/>
        <name nil="true"/>
        <status nil="true"/>
        <reviewlink nil="true"/>
        <proxylink nil="true"/>
        <blogmap nil="true"/>
        <street nil="true"/>
        <city nil="true"/>
        <state nil="true"/>
        <zip nil="true"/>
        <country nil="true"/>
        <phone nil="true"/>
        <overall nil="true"/>
        <imagecount nil="true"/>
      </location>
    </bmp-locations>
    END_OF_STRING

    stub_request(:get, /.*nowhere/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("nowhere")

    expect(places.size).to eq(0)
  end

  it "when HTTP GET returns several entries, an array containing all places is returned" do

    canned_answer = <<-END_OF_STRING
    <?xml version="1.0" encoding="UTF-8"?>
    <bmp_locations>
    <location type="array">
      <location>
        <id>18844</id>
        <name>Stadin Panimo</name>
        <status>Brewery</status>
        <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18844</reviewlink>
        <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18844&amp;d=5</proxylink>
        <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18844&amp;d=1&amp;type=norm</blogmap>
        <street>Kaasutehtaankatu 1, rakennus 6</street>
        <city>Helsinki</city>
        <state nil="true"/>
        <zip>00540</zip>
        <country>Finland</country>
        <phone>09 170512</phone>
        <overall>0</overall>
        <imagecount>0</imagecount>
      </location>
      <location>
        <id>18855</id>
        <name>Panimoravintola Bruuveri</name>
        <status>Brewpub</status>
        <reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18855</reviewlink>
        <proxylink>http://beermapping.com/maps/proxymaps.php?locid=18855&amp;d=5</proxylink>
        <blogmap>http://beermapping.com/maps/blogproxy.php?locid=18855&amp;d=1&amp;type=norm</blogmap>
        <street>Fredrikinkatu 63AB</street>
        <city>Helsinki</city>
        <state nil="true"/>
        <zip>00100</zip>
        <country>Finland</country>
        <phone>09 685 66 88</phone>
        <overall>0</overall>
        <imagecount>0</imagecount>
        </location>
      </location>
    </bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("helsinki")

    expect(places.size).to eq(2)
    place = places[0]
    expect(place.name).to eq("Stadin Panimo")
    expect(place.street).to eq("Kaasutehtaankatu 1, rakennus 6")

    place = places[1]
    expect(place.name).to eq("Panimoravintola Bruuveri")
    expect(place.street).to eq("Fredrikinkatu 63AB")
  end

  describe "in case of cache miss" do

  before :each do
    Rails.cache.clear
  end

  it "When HTTP GET returns one entry, it is parsed and returned" do
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Gallows Bird")
    expect(place.street).to eq("Merituulentie 30")
  end

end

describe "in case of cache hit" do

  before :each do
    Rails.cache.clear
  end

  it "When one entry in cache, it is returned" do
    canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

    # ensure that data found in cache
    BeermappingApi.places_in("espoo")

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("O'Connell's Irish Bar")
    expect(place.street).to eq("Rautatienkatu 24")
  end
end


end
