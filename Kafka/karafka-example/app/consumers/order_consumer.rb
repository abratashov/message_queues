class OrderConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      # order = JSON.parse(message.payload)
      order = message.payload
      puts "Processing order ##{order['id']} for #{order['customer']} - Total: $#{order['total']}"
      # Simulate saving to a database or further processing
    end
  end
end
