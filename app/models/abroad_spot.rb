class AbroadSpot
  API_URL = "http://webservice.recruit.co.jp/ab-road/spot/v1/"
  FORMAT = "json"
  COUNT = 100

  def initialize
    @appid = ENV["ABROAD_APPID"]
  end

  def get_spots(city: nil, start: 1, count: 10)
    httpClient = HTTPClient.new
    jsonData = nil
    begin
      data = httpClient.get_content(API_URL, {
        "key" => @appid,
        "city" => city,
        "format" => FORMAT,
        "start" => start,
        "count" => count
      })
      jsonData = JSON.parse data
      Rails.logger.debug('<spots_available> = ' + jsonData['results']['results_available'].to_s)
      # Rails.logger.debug('<results_returned>  = ' + jsonData['results']['results_returned'].to_s)
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    return jsonData
  end
end
