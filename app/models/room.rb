class Room < ApplicationRecord
  belongs_to :user,optional: true
  has_many :reservations, dependent: :destroy
  
  mount_uploader :image, ImageUploader

  with_options presence: true do
    validates :roomname
    validates :detail
    validates :price
    validates :address
  end
  
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}


  def self.search_area(area)
     where(["address like?", "%#{area}%"])  
  end
 
  def self.search(keyword) 
    where(["roomname like? OR price like? OR detail like? OR address like?","%#{keyword}%","%#{keyword}%","%#{keyword}%","%#{keyword}%"]) 
  end
end
