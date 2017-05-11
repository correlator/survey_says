class Order < ApplicationRecord
  validates :description, presence: true
  validates :vendor_id, presence: true
  validates :price_in_cents, presence: true
  validates :close_date, presence: true
  belongs_to :vendor
  has_many :order_participants
  has_many :participants, through: :order_participants
  enum status: { pending: 0, active: 1, complete: 2 }

  after_save :update_status

  def update_status
    complete! if active_and_past_close_date?
  end

  def activate!
    return unless status == 'pending'
    update(status: :active)
  end

  def complete!
    return unless status == 'active'
    update(status: :complete)
  end

  private

  def active_and_past_close_date?
    status == 'active' && Date.today >= close_date
  end
end
