require 'concurrent'

class AbroadTour
  API_URL = "http://webservice.recruit.co.jp/ab-road/tour/v1/"
  FORMAT = "json"
  COUNT = 100
  CACHE_EXPIRE = 1.hour

  # futureの画面間受け渡し用のhash
  @@futures = {}

  def initialize
    @appid = ENV["ABROAD_APPID"]
    @sessionId = Thread.current[:request].session_options[:id]
  end

  def preload_tours(keyword, dept="TYO", start=1, count=10)
    # キャッシュまたはfutureが既に存在する場合は、何もしない
    # 存在しない場合は、futureでAPIを実行し、そのfutureをクラス変数のhashにセットする
    if (Rails.cache.exist?(keyword) || @@futures.has_key?(keyword + @sessionId))
      return
    end
    future = Concurrent::Future.new(task: true) {
      get_tours_by_keyword(keyword, dept, start, count)
    }.execute
    @@futures.store(keyword + @sessionId, future)
  end

  def get_random_tours_by_keyword(keyword, dept="TYO", start=1, count=10)
    # キャッシュに存在する場合は、そのhashを利用する
    toursHash = Rails.cache.fetch(keyword, expires_in: CACHE_EXPIRE) do
      # キャッシュが存在しない場合は、futureがあればfutureから取得し、無い場合はAPI呼び出しを行う。
      # 実行結果はキャッシュに登録される。
      future = @@futures.delete(keyword + @sessionId)
      if (future != nil )
        puts "by future"
        # futureが処理中の場合は、処理が終わるまでブロックされる
        future.value
      else
        puts "no cache"
        get_tours_by_keyword(keyword, dept, start, count)
      end
    end
    if (toursHash.nil?)
      Rails.cache.delete(keyword)
      return nil 
    end
    # 引数で指定された件数のツアー情報を配列で返す
    # return hash.values[(start-1)...(start-1+count)]
    # Sprint4暫定ロジック。ランダムに10個返す
    spotModel = AbroadSpot.new
    tours = toursHash.values.sample(count).sort{|a, b| a["dest"]["lng"].to_i <=> b["dest"]["lng"].to_i}
    tours.each do |tour|
      lat = tour["dest"]["lat"]
      lng = tour["dest"]["lng"]
      city = tour["dest"]["name"]
      cityCode = tour["dest"]["code"]
      country = tour["dest"]["country"]["name"]
      dest = Rails.cache.fetch(cityCode, expires_in: CACHE_EXPIRE) do
        Destination.new(city: city, cityCode: cityCode, country: country, lat: lat, lng: lng)
      end
      # dest = Destination.new(lat: tour["dest"]["lat"], lng: tour["dest"]["lng"])
      # パノラミオ画像URL取得
      tour["panoramio_photos"] = dest.get_panoramio_photos
      # スポット情報取得
      tour["spots"] = spotModel.get_spots(city: tour["dest"]["code"], count: 100)['results']['spot'].sample(5)
    end
    return tours
  end

  def get_tours_by_keyword(keyword, dept="TYO", start=1, count=10)
    # 定数で指定した件数を1件目から取得
    tours = get_tours(keyword: keyword, dept: dept, start: 1, count: COUNT)
    resAvailable = tours["results"]["results_available"].to_i
    resReturned = tours["results"]["results_returned"].to_i
    tourArray = tours["results"]["tour"]
    # 検索結果が取得件数以上の場合、定数で指定された件数分末尾から取得しマージする
    if resAvailable > resReturned
      toursTail = get_tours(keyword: keyword, dept: dept, start: resAvailable>COUNT*2 ? resAvailable-COUNT : COUNT+1, count: COUNT)
      tourArray.concat(toursTail["results"]["tour"])
    end
    # 結果から、重複するツアーをhashで除外する
    hash = Hash.new
    tourArray.each{|item|
      if item["dest"]["lat"].empty?
        next
      end
      # 重複排除のkeyに緯度・経度を利用。地図のマーカが重ならないように。
      key = item["dest"]["lat"].to_s + "," + item["dest"]["lng"].to_s
      unless hash.has_key?(key)
        hash.store(key, item)
      end
    }
    p hash.length
    return hash
  end

  def get_tours_by_priceterm(minPrice: nil, maxPrice: nil, minTerm: nil, maxTerm: nil)
    return get_tours(minPrice: minPrice, maxPrice: maxPrice, minTerm: minTerm, maxTerm: maxTerm, adType: 'F')
  end
 
  def get_tour(id: id)
    return get_tours(id: id)['results']['tour'][0]
  end

  private
  def get_tours(id: nil, keyword: nil, dept: "TYO", start: 1, count: 10,
                minPrice: nil, maxPrice: nil, minTerm: nil, maxTerm: nil, adType: nil)
    httpClient = HTTPClient.new
    jsonData = nil
    begin
      data = httpClient.get_content(API_URL, {
        "key" => @appid,
        "id" => id,
        "keyword" => keyword,
        "dept" => dept,
        "format" => FORMAT,
        "price_min" => minPrice, "price_max" => maxPrice,
        "term_min" => minTerm, "term_max" => maxTerm,
        "ad_type" => adType,
        "start" => start,
        "count" => count
      })
      jsonData = JSON.parse data
      Rails.logger.debug('<results_available> = ' + jsonData['results']['results_available'])
      Rails.logger.debug('<results_returned>  = ' + jsonData['results']['results_returned'])
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
    return jsonData
  end
end
