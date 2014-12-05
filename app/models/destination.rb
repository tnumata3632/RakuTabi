require 'openssl'

class Destination
  WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
  INSTAGRAM_URL = "https://api.instagram.com/v1/media/search"
  INSTAGRAM_CLIENT_ID = "954787f7f2b6464b98dbb73fb2492523"
  PANORAMIO_URL = "http://www.panoramio.com/map/get_panoramas.php"

  attr_accessor :city, :cityCode, :country, :countryCode, :lat, :lng

  def initialize(city: nil, cityCode: nil, country: nil, countryCode: nil, lat: nil, lng: nil)
    @city = city
    @cityCode = cityCode
    @country = country
    @countryCode = countryCode
    @lat = lat
    @lng = lng
  end

  def get_weather
    jsonData = nil
    begin
      httpClient = HTTPClient.new
      data = httpClient.get_content(WEATHER_URL, { "lat" => @lat,  "lon" => @lng })
      jsonData = JSON.parse data
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    return jsonData
  end

  def get_hashtag_for_instagram
    city = City.find_by(city_jp: @city)
    ap city
    if city.nil?
      city = City.newInstanceByAbroadApi(@cityCode)
    end
    cityname = city.city_en.gsub(" ", "").split(".")[0]
    p cityname
    tag = cityname
    #url = "https://api.instagram.com/v1/tags/#{foodtag}/media/recent"
    #data = call_api(url, {"client_id" => INSTAGRAM_CLIENT_ID})
  end

  def get_instagram_photos
    jsonData = nil
    begin
      httpClient = HTTPClient.new
      data = httpClient.get_content(INSTAGRAM_URL, {
        "lat" => @lat,
        "lng" => @lng,
        "client_id" => INSTAGRAM_CLIENT_ID
      })
      jsonData = JSON.parse data
    end
    return jsonData['data']
  end

  def get_panoramio_photos
    Rails.logger.debug("Get Panoramio...")
    @delta = 0.1
    @latf = @lat.to_f
    @lngf = @lng.to_f
    jsonData = nil
    begin
      httpClient = HTTPClient.new
      data = httpClient.get_content(PANORAMIO_URL, {
        "set" => "public",
        "from" => "0",
        "to" => "10",
        "miny" => @latf - @delta,
        "minx" => @lngf - @delta,
        "maxy" => @latf + @delta,
        "maxx" => @lngf + @delta,
        "size" => "original",
        "mapfilter" => "true",
      })
      jsonData = JSON.parse data
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    Rails.logger.debug("Get Panoramio finished!")
    return jsonData["photos"]
  end
end
