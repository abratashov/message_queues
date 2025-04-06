class SimpleConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      # payload = JSON.parse(message.payload)  # Assuming JSON payload
      ap 'Received message:'
      ap message.payload
    end
  end
end
