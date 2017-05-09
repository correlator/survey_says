class Participant < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true,
                    format: {
                      with: /\d{10}/,
                      message: "phone must be 10 digits"
                    }
  validates :email, presence: true,
                    format: {
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
                    }
end
