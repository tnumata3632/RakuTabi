class City < ActiveRecord::Base
  include Api
  def self.newInstanceByAbroadApi(code)
    api_url = "http://webservice.recruit.co.jp/ab-road/city/v1/"
    format = "json"
    app_id = ENV["ABROAD_APPID"]
    param = {
        "key" => app_id,
        "format" => format,
        "city" => code
    }
    data = City.call_api(api_url, param)
    cities = data["results"]["city"]
    unless cities.blank?
      p cities[0]["name_en"]
      return City.new(city_en: cities[0]["name_en"])
    end
    return nil
  end
end
