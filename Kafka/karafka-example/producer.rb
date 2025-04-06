require 'bundler/setup'
require './karafka'  # Load Karafka configuration

# By default karafka uses waterdrop producer
# https://github.com/karafka/waterdrop

ap '#################### 00 Scenario 0: Produce a simple message'
payload = { message: 'Hello from Karafka!', timestamp: Time.now.to_s }.to_json
Karafka.producer.produce_sync(topic: 'simple_topic', payload: payload)

ap 'Message sent:'
ap payload

ap '#################### 01 Scenario 1: Order Processing System (Basic Batch Processing)'

orders = [
  { id: 1, customer: 'Alice', total: 29.99 },
  { id: 2, customer: 'Bob', total: 49.50 }
]

orders.each do |order|
  Karafka.producer.produce_sync(topic: 'orders', payload: order.to_json)
  ap "Sent order ##{order[:id]}"
end

ap '#################### 02 Scenario 2: Email Notification Queue (Error Handling & Dead Letter Queue)'

notifications = [
  { email: 'alice@example.com', message: 'Order shipped!' },
  { email: 'bob@invalid.com', message: 'Payment failed!' }
]

notifications.each do |notif|
  Karafka.producer.produce_sync(topic: 'notifications', payload: notif.to_json)
  ap "Sent notification to #{notif[:email]}"
end
