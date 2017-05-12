class TwilioClient
  def initialize
    @client = Twilio::REST::Client.new
  end

  def send_text(phone, message)
    @client.messages.create(
       from: '+18056284804',
       to: '+1' + phone,
       body: message)
  end
end
