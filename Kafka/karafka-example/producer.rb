require 'bundler/setup'
require './karafka'  # Load Karafka configuration

# Produce a simple message
payload = { message: 'Hello from Karafka!', timestamp: Time.now.to_s }.to_json
Karafka.producer.produce_sync(topic: 'simple_topic', payload: payload)

puts 'Message sent:'
p payload
