class Destination
  WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
  attr_accessor :city, :country, :lat, :lng

  def initialize(city: nil, country: nil, lat: nil, lng: nil)
    @city = city
    @country = country
    @lat = lat
    @lng = lng
  end

  def get_weather
    jsonData = nil
    begin
      httpClient = HTTPClient.new
      data = httpClient.get_content(WEATHER_URL, { "q" => @city + "," + @country })
      jsonData = JSON.parse data
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    return jsonData
  end

  def get_tours
  end
end
