class TourController < ApplicationController
  include TourHelper
  before_filter :set_request

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
    tour = AbroadTour.new
    @tourDetail= tour.get_tour(id: params[:tourid])
    lat = @tourDetail["dest"]["lat"]
    lng = @tourDetail["dest"]["lng"]
    destination = Destination.new(lat: lat, lng: lng)
    ap destination
    weather = destination.get_weather
    @temperature = kelvin_to_celsius(weather["main"]["temp"])
    @photos = destination.get_instagram_photos()
  end

  def get_weather
  end

  private
    def set_request
      Thread.current[:request] = request
    end
end
