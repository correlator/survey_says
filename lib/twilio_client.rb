class TwilioClient
  def initialize
    @client = Twilio::REST::Client.new
  end

  def send_text(phone, message)
    return unless Rails.env == 'production'
    @client.messages.create(
       from: '+18056284804',
       to: '+1' + phone,
       body: message)
  end
end
