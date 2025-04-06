class NotificationConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      # payload = JSON.parse(message.payload)
      payload = message.payload
      begin
        # Simulate email sending (fails if email is invalid)
        raise "Invalid email" if payload['email'].include?('invalid')
        ap "Sending email to #{payload['email']}: #{payload['message']}"
      rescue StandardError => e
        # Move to DLQ after max retries (simplified here)
        Karafka.producer.produce_sync(topic: 'notifications_dlq', payload: message.payload.to_json)
        ap "Moved to DLQ: #{payload['email']} - Error: #{e.message}"
      end
    end
  end
end
