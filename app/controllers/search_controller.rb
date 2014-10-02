class SearchController < ApplicationController
  def search
    httpClient = HTTPClient.new
    appid = ENV["APPID"]
    afid = ENV["AFID"]
    appid = '1015756569079501204'
    afid = '131ebb35.37b19196.131ebb36.64da1433'
    p appid
    p afid
    @jsonData = nil
    @errorMsg = nil
    
    begin
      data = httpClient.get_content('https://app.rakuten.co.jp/services/api/Travel/HotelRanking/20131024', {
          'applicationId' => appid,
          'affiliateId'   => afid,
          'genre'         => 'onsen'
      })
      @jsonData = JSON.parse data
      p @jsonData
    rescue HTTPClient::BadResponseError => e
    rescue HTTPClient::TimeoutError => e
    end
    # render 'itemsearch/index'
  end
end
