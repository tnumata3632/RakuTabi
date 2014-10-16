class TourController < ApplicationController
  def select
    @image_l = Image.find_by(:image_id => "town")
    @image_r = Image.find_by(:image_id => "sea")
    @image_dummy = Image.new
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
    @jsonData = tour.get_tours(keyword, dept)
    p keyword
  end
end
