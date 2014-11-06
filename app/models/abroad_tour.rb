require 'concurrent'

class AbroadTour
  API_URL = "http://webservice.recruit.co.jp/ab-road/tour/v1/"
  FORMAT = "json"
  COUNT = 100
  CACHE_EXPIRE = 1.hour

  @@futures = {}

  def initialize
    @appid = ENV["ABROAD_APPID"]
    @sessionId = Thread.current[:request].session_options[:id]
  end

  def preload_tours(keyword, dept="TYO", start=1, count=10)
    if (Rails.cache.exist?(keyword))
      return nil
    end
    future = Concurrent::Future.new {
      get_tours_by_keyword(keyword, dept="TYO", start=1, count=10)
    }.execute
    # return future
    @@futures.store(keyword + @sessionId, future)
  end

  def get_random_tours_by_keyword(keyword, dept="TYO", start=1, count=10)
    toursHash = Rails.cache.fetch(keyword, expires_in: CACHE_EXPIRE) do
      future = @@futures.delete(keyword + @sessionId)
      if (future != nil )
        puts "by future"
        future.value
      else
        puts "no cache"
        get_tours_by_keyword(keyword, dept="TYO", start=1, count=10)
      end
    end
    # 引数で指定された件数のツアー情報を配列で返す
    # return hash.values[(start-1)...(start-1+count)]
    # Sprint4暫定ロジック。ランダムに10個返す
    # return hash.values.sample(count)
    return toursHash.values.sample(count)
  end

  def get_tours_by_keyword(keyword, dept="TYO", start=1, count=10)
    # 最初の100件取得
    tours = get_tours(keyword: keyword, dept: dept, start: 1, count: COUNT)
    resAvailable = tours["results"]["results_available"].to_i
    resReturned = tours["results"]["results_returned"].to_i
    tourArray = tours["results"]["tour"]
    # 検索結果が100件以上の場合、最後の100件を取得し最初の100件とマージする
    if resAvailable > resReturned
      toursTail = get_tours(keyword: keyword, dept: dept, start: resAvailable>COUNT*2 ? resAvailable-COUNT : COUNT+1, count: COUNT)
      tourArray.concat(toursTail["results"]["tour"])
    end
    # 結果から、同一の宿泊地要約のツアーをhashで除外する
    hash = Hash.new
    tourArray.each{|item|
      # key = item["city_summary"]
      if item["dest"]["lat"].empty?
        next
      end
      key = item["dest"]["lat"].to_s + "," + item["dest"]["lng"].to_s
      unless hash.has_key?(key)
        hash.store(key, item)
      end
    }
    p hash.length
    return hash
  end

  def get_tours(id: nil, keyword: nil, dept: "TYO", start: 1, count: 10)
    httpClient = HTTPClient.new
    jsonData = nil
    begin
      data = httpClient.get_content(API_URL, {
        "key" => @appid,
        "id" => id,
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
