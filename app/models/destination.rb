class Weather

  def get_weather(city, country)
    begin
      httpClient = HTTPClient.new
      data = httpClient.get_content("http://api.openweathermap.org/data/2.5/weather", { "q" => city + "," + country })
      jsonData = JSON.parse data
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
  end
end