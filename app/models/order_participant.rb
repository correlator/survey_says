class OrderParticipant < ApplicationRecord
  validates :order_id, presence: true
  validates :participant_id, presence: true
  belongs_to :order
  belongs_to :participant
  enum status: { pending: 0, sent: 1, approved: 2 }

  scope :sent, -> { where(status: 'sent') }
  scope :approved, -> { where(status: 'approved') }

  def send!
    return unless status == 'pending'
    update(status: :sent)
  end

  def approve!
    return unless status == 'sent'
    update(status: :approved)
    order.update_status
  end
end
