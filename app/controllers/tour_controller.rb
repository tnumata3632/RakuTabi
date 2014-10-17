class TourController < ApplicationController
  def select
    # get diffrent two images
    begin
      images = Image.all.sample(2)
    end while (images[0].image_id == images[1].image_id)

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
    @jsonData = tour.get_tours(keyword, dept)
    p "dept    = " + dept
    p "keyword = " + keyword
  end
end
