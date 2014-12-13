class TourController < ApplicationController
  before_filter :set_request

  CACHE_EXPIRE = 1.hour

  def select
    # get diffrent two images
    begin
      images = Image.all.sample(2)
    end while (images[0].image_id == images[1].image_id)

    # 対象のツアー情報を事前ロードする
    tour = AbroadTour.new
    images.each do |item|
      tour.preload_tours(item.keywords)
    end

    @image_l = images[0]
    @image_r = images[1]
  end

  def search
    tour = AbroadTour.new
    image = Image.find_by(:image_id => params[:imgid])
    if (image != nil)
      keyword = image.keywords
    else
      keyword = "世界遺産 トルコ フィンランド"
    end
    dept = "TYO"
    @tours = tour.get_random_tours_by_keyword(keyword, dept)
    p "dept    = " + dept
    p "keyword = " + keyword
  end

  def detail
    cityCode = params[:citycode]
    ap cityCode
    destination = Rails.cache.fetch(cityCode, expires_in: CACHE_EXPIRE) do
      tour = AbroadTour.new
      @tourDetail= tour.get_tour(id: params[:tourid])
      lat = @tourDetail["dest"]["lat"]
      lng = @tourDetail["dest"]["lng"]
      city = @tourDetail["dest"]["name"]
      cityCode = @tourDetail["dest"]["code"]
      country = @tourDetail["dest"]["country"]["name"]
      Destination.new(city: city, cityCode: cityCode, country: country, lat: lat, lng: lng)
    end
    @cityEn = destination.get_cityname_en()
    @cityJp = destination.get_cityname_jp()
  end

  def ask
    # begin

    if params[:askid].nil?
      ask = Ask.all.sample(1)
      @next= "/ask?askid=" + ask[0].id.to_s
      @current= "/ask?askid=" + ask[0].id.to_s
     else
      begin
        ask = Ask.all.sample(1)
      end while (params[:askid] == ask[0].id.to_s)
      @next= "/selection"
      @current= "/ask?askid=" + params[:askid]
    end


    # end while (images[0].image_id == images[1].image_id)

    @ask= ask[0]

  end

  private
    def set_request
      Thread.current[:request] = request
    end

    def kelvin_to_celsius(degree)
      absolute_zero = - 273.15
      (degree.to_f + absolute_zero).round
    end

end
