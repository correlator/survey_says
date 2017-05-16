require 'twilio_client'

class Order < ApplicationRecord
  delegate :url_helpers, to: 'Rails.application.routes'

  validates :description, presence: true
  validates :vendor_id, presence: true
  validates :price_in_cents, presence: true
  validates :close_date, presence: true
  belongs_to :vendor
  has_many :order_participants
  has_many :participants, through: :order_participants
  enum status: { pending: 0, active: 1, complete: 2 }

  DATA_ATTRIBUTE_OPTIONS = ['Address', 'Income', 'Insurance Coverage',
                            'Insurance Usage', 'Retirement Plan', 'Job Title',
                            'CoPay Usage', 'Car Driven', 'Genome Sequence',
                            'Flu Shot History', 'Social Media Profiles',
                            'Lab Test Results']
  after_save :update_status

  def update_status
    complete! if active_and_past_close_date?
  end

  def activate!
    return unless status == 'pending'
    update(status: :active)
    send_message_to_participants!
  end

  def complete!
    return unless status == 'active'
    update(status: :complete)
  end

  private

  def active_and_past_close_date?
    status == 'active' && Date.today >= close_date
  end

  def send_message_to_participants!
    order_participants.each do |order_participant|
			client = TwilioClient.new
      client.send_text(order_participant.participant.phone, message(order_participant))
    end
  end

  def message(order_participant)
    raw_message = "#{vendor.name} would like to purchase your data "
    raw_message += "for $#{price_in_cents.to_f * 0.01}. "
    raw_message += "Give your consent at: "
    raw_message += url_helpers.order_participant_url(order_participant, host: 'dataconsent.herokuapp.com')
    raw_message
  end
end
