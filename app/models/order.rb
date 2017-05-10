class Order < ApplicationRecord
  validates :description, presence: true
  validates :vendor_id, presence: true
  validates :price_in_cents, presence: true
  validates :close_date, presence: true
  belongs_to :vendor
  enum status: { pending: 0, active: 1, complete: 2 }

  def activate!
    return unless status == 'pending'
    update(status: :active)
  end

  def complete!
    return unless status == 'active'
    update(status: :complete)
  end
end
