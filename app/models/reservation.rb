class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  mount_uploader :image, ImageUploader
  
  with_options presence: true do
    validates :user_id
    validates :room_id
    validates :check_in
    validates :check_out
    validates :number
  end
  
  validates :number,numericality: {only_integer: true,greater_than_to: 0}

  validate :start_end_check

  def start_end_check
    unless check_in == nil || check_out ==nil
    errors.add(:check_out, "は開始日より後のものを選択してください") unless
    self.check_in < self.check_out
    end
  end

  def total
    (self.check_out - self.check_in).to_i * self.number.to_i * self.price.to_i
  end
end
