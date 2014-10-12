class TourController < ApplicationController
  def select
  end

  def search
    tour = AbroadTour.new
    keyword = "世界遺産 トルコ フィンランド"
    dept = "TYO"
    @jsonData = tour.get_tours(keyword, dept)
  end
end
