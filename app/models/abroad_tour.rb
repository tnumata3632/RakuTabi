class AbroadTour
  API_URL = "http://webservice.recruit.co.jp/ab-road/tour/v1/"
  FORMAT = "json"
  COUNT = 100

  def initialize
    @appid = ENV["ABROAD_APPID"]
  end

  def get_tours(keyword, dept="TYO")
    allTours = get_tours_all(keyword, dept, 1, COUNT)
    numOfTours = allTours["results_returned"]
    p numOfTours
    hash = Hash.new
    allTours["results"]["tour"].each{|item|
      key = item['city_summary']
      unless hash.has_key?(key)
        hash.store(key, item)
        if hash.length > 14
          break 
        end
      end
    }
    return hash.values
  end

  def get_tours_all(keyword, dept="TYO", start=1, count=10)
    httpClient = HTTPClient.new
    jsonData = nil
    begin
      data = httpClient.get_content(API_URL, {
        "key" => @appid,
        "keyword" => keyword,
        "dept" => dept,
        "format" => FORMAT,
        "start" => start,
        "count" => count
      })
      jsonData = JSON.parse data
      Rails.logger.debug(jsonData.inspect)
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    return jsonData
  end 
end
