require 'bundler/setup'
require './karafka'  # Load Karafka configuration

# By default karafka uses waterdrop producer
# https://github.com/karafka/waterdrop

puts '############################# 00 Scenario 0: Produce a simple message'
payload = { message: 'Hello from Karafka!', timestamp: Time.now.to_s }.to_json
Karafka.producer.produce_sync(topic: 'simple_topic', payload: payload)

puts 'Message sent:'
p payload

puts '############################# 01 Scenario 1: Order Processing System (Basic Batch Processing)'

orders = [
  { id: 1, customer: 'Alice', total: 29.99 },
  { id: 2, customer: 'Bob', total: 49.50 }
]

orders.each do |order|
  Karafka.producer.produce_sync(topic: 'orders', payload: order.to_json)
  puts "Sent order ##{order[:id]}"
end
