class Photo < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :image, presence: true
  belongs_to :category
  belongs_to :studio
  has_many :order_photos, dependent: :destroy
  has_many :orders, through: :order_photos
  has_many :user_photos
  has_many :users, through: :user_photos
  attr_accessor :image

  has_attached_file :image, :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename",
    styles: {
      favicon: '16x16>',
      square: '200x200#',
      medium: '300x300>'
    }

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_reader :category

  def convert_price_to_cents
    self.update(price: price * 100)
  end

  def status
    active ? "Active" : "Inactive"
  end

  def self.random_category_photo(category)
    if !category.photos.empty?
      photo = where(category_id: Category.find_by(name: category.name).id).shuffle.pop
    else
      photo = first
    end
    photo
  end

  def category
    Category.find_by(id: self.category_id)
  end

  def self.random_studio_photo(studio)
    if !studio.photos.empty?
      photo = where(studio_id: Studio.find_by(name: studio.name).id).shuffle.pop
    else
      photo = first
    end
    photo
  end
end
