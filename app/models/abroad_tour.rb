class AbroadTour
  API_URL = "http://webservice.recruit.co.jp/ab-road/tour/v1/"
  FORMAT = "json"
  COUNT = 100

  def initialize
    @appid = ENV["ABROAD_APPID"]
  end

  def get_tours(keyword, dept="TYO", start=1, count=10)
    # 最初の100件取得
    tours = get_tours_all(keyword, dept, 1, COUNT)
    resAvailable = tours["results"]["results_available"].to_i
    resReturned = tours["results"]["results_returned"].to_i
    tourArray = tours["results"]["tour"]
    # 検索結果が100件以上の場合、最後の100件を取得し最初の100件とマージする
    if resAvailable > resReturned
      toursTail = get_tours_all(keyword, dept, resAvailable>COUNT*2 ? resAvailable-COUNT : COUNT+1, COUNT)
      tourArray.concat(toursTail["results"]["tour"])
    end
    # 結果から、同一の宿泊地要約のツアーをhashで除外する
    hash = Hash.new
    tourArray.each{|item|
      key = item["city_summary"]
      if item["dest"]["lat"].empty?
        next
      end
      unless hash.has_key?(key)
        hash.store(key, item)
      end
    }
    p hash.length
    # 引数で指定された件数のツアー情報を配列で返す
    # return hash.values[(start-1)...(start-1+count)]
    # Sprint4暫定ロジック。ランダムに10個返す
    return hash.values.sample(count)
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
