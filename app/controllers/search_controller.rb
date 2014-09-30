class SearchController < ApplicationController
  def search
    # keyword = params['keyword']
    httpClient = HTTPClient.new
    appid = ENV["APPID"]
    afid = ENV["AFID"]
    @jsonData = nil
    @errorMsg = nil
    
    begin
      data = httpClient.get_content('https://app.rakuten.co.jp/services/api/Travel/HotelRanking/20131024', {
          'applicationId' => appid,
          'affiliateId'   => afid,
          'genre'         => 'onsen'
          # 'keyword'       => 'iphone6'
      })
      @jsonData = JSON.parse data
      p @jsonData
    rescue HTTPClient::BadResponseError => e
    rescue HTTPClient::TimeoutError => e
    end
    # render 'itemsearch/index'
  end
end
