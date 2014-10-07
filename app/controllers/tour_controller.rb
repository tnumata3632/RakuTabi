class TourController < ApplicationController
  def tour
    httpClient = HTTPClient.new
    abroadAppid = ENV["ABROAD_APPID"]
    p abroadAppid
    @jsonData = nil
    @errorMsg = nil
    
    begin
	  data = httpClient.get_content('http://webservice.recruit.co.jp/ab-road/tour/v1/', {
        'key' => abroadAppid,
        'keyword' => '世界遺産 トルコ フィンランド',
        'dept' => 'TYO',
        'format' => 'json'
      })
      @jsonData = JSON.parse data
      p @jsonData
      rescue HTTPClient::BadResponseError => e
      rescue HTTPClient::TimeoutError => e
    end
  end
end
