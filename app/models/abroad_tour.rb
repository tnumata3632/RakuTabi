class AbroadTour
  API_URL = "http://webservice.recruit.co.jp/ab-road/tour/v1/"
  FORMAT = "json"

  def initialize
    @appid = ENV["ABROAD_APPID"]
  end

  def get_tours(keyword, dept)
    httpClient = HTTPClient.new
    jsonData = nil
    begin
      data = httpClient.get_content(API_URL, {
        "key" => @appid,
        "keyword" => keyword,
        "dept" => dept,
        "format" => FORMAT
      })
      jsonData = JSON.parse data
      Rails.logger.debug(jsonData.inspect)
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    return jsonData
  end 
end
