class TourController < ApplicationController
  def select
    @image_l = Image.find_by(:image_id => "town")
    @image_r = Image.find_by(:image_id => "sea")
    @image_dummy = Image.new
  end

  def search
    tour = AbroadTour.new
    keyword = "世界遺産 トルコ フィンランド"
    dept = "TYO"
    @jsonData = tour.get_tours(keyword, dept)
  end
end
