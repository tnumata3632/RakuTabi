class TourController < ApplicationController
  def select
  end

  def search
    tour = AbroadTour.new
    case params[:imgid]
    when "town"
      keyword = "街 ニューヨーク"
    when "sea"
      keyword = "海 ビーチ"
    else
      keyword = "世界遺産 トルコ フィンランド"
    end
    dept = "TYO"
    @jsonData = tour.get_tours(keyword, dept)
  end
end
