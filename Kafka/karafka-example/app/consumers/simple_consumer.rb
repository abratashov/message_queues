class SimpleConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      # payload = JSON.parse(message.payload)  # Assuming JSON payload
      puts 'Received message:'
      p message.payload
    end
  end
end
