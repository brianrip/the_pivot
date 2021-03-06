class Order < ActiveRecord::Base
  validates :status, presence: true
  belongs_to :user
  has_many :order_photos
  has_many :photos, through: :order_photos


  def placed_at
    created_at.strftime("%B %d, %Y")
  end

  def studio_price(studio)
    price = 0
    order_photos.each do |order_photo|
      if order_photo.photo.studio == studio
        price += order_photo.photo.price
      end
    end
    price / 100.0
  end

  def format_total_price
    "$#{'%.02f' % (total_price / 100.0)}"
  end

  def self.studio_specific_orders(studio)
    joins(photos: :studio).where("studios.id = #{studio.id}").distinct
  end
end
