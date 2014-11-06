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
    future = Concurrent::Future.new {
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
    # 引数で指定された件数のツアー情報を配列で返す
    # return hash.values[(start-1)...(start-1+count)]
    # Sprint4暫定ロジック。ランダムに10個返す
    return toursHash.values.sample(count)
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

  def get_tours_all_m(keyword, dept="TYO", start=1, count=10)
    jsonData = {"results" => {
      "results_available" => 2,
      "results_returned" => 2,
      "tour" => [
      {
        "dest" => {
          "lat" => "16.0550517622",
          "lng" => "108.2235717773",
          "name" => "ダナン"
        },
        "img" => [
          {
            "l"=>"http://www.ab-road.net/tour_img/size_l/1756578003_393400_l.jpg",
            "caption"=>"ランタン／イメージ"
          },
        ],
        "urls" => {
          "pc"=>"http://google.co.jp/"
        },
        "id" => "AD04H0SV",
        "city_summary" => "ダナン",
        "title" => "ベトナム航空で行く 世界遺産の街　ダナン乗継便5日間！...",
      },
      {
        "dest" => {
          "lat" => "14.0283490000",
          "lng" => "99.5299530000",
          "name" => "カンチャナブリ"
        },
        "img" => [
          {
            "l"=>"http://www.ab-road.net/tour_img/size_l/3196435002_415182_l.jpg",
            "caption"=>"アユタヤ　世界遺産祭り"
          },
        ],
        "urls" => {
          "pc"=>"http://google.co.jp/"
        },
        "id" => "AC862685",
        "city_summary" => "バンコク、カンチャナブリ",
        "title" => "2014年　アユタヤ世界遺産祭り2014年を見学♪♪　■　キャセイ航空利用 ...",
      },
      {
        "dest" => {
          "lat" => "45.4341170000",
          "lng" => "12.3390200000",
          "name" => "ベネチア"
        },
        "img" => [
        ],
        "urls" => {
          "pc"=>"http://google.co.jp/"
        },
        "id" => "AD04KMDK",
        "city_summary" => "ベネチア",
        "title" => "【イタリアお祭りツアー】 ★世界三大祭り！仮面カーニバルへ行く ...",
      },
      ]
    }}
    return jsonData
  end 
end
