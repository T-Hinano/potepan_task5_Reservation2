class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :profileimage,ProfileimageUploader
  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy
       
  def already_reservated?(user)
    self.reservations.exists?(room_id: room.id)
  end
end
