class Participant < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true,
                    format: {
                      with: /\A\d{10}\z/,
                      message: "phone must be 10 digits"
                    }
  validates :email, presence: true,
                    format: {
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
                    }
  has_many :order_participants
  has_many :orders, through: :order_participants
end
