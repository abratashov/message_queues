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

ap '#################### 03 Scenario 3: User Activity Tracking (Partitioning & Concurrency)'

# Create partitions:
# $ docker exec -it kafka bash
# docker$ /bin/kafka-topics --delete --topic user_activity --bootstrap-server localhost:9092
# docker$ /bin/kafka-topics --create --topic user_activity --partitions 2 --replication-factor 1 --bootstrap-server localhost:9092

activities = [
  { user_id: 1, action: 'viewed homepage' },
  { user_id: 2, action: 'clicked product' },
  { user_id: 3, action: 'added to cart' },
  { user_id: 4, action: 'added to cart 1' },
  { user_id: 5, action: 'added to cart 2' },
  { user_id: 6, action: 'added to cart 3' },
  { user_id: 7, action: 'added to cart 4' },
  { user_id: 8, action: 'added to cart 5' }
]

activities.each do |activity|
  # Partition key based on user_id for consistent distribution
  Karafka.producer.produce_sync(topic: 'user_activity', payload: activity.to_json, key: activity[:user_id].to_s)
  puts "Sent activity for user #{activity[:user_id]}"
end

ap '#################### 04 Scenario 4: Long-Running Data Import (Long-Running Jobs)'

Karafka.producer.produce_sync(topic: 'data_imports', payload: { file: 'users.csv' }.to_json)
puts "Sent import job for users.csv"
