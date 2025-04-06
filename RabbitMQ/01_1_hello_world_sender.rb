# RabbitMQ tutorial - "Hello World!"
# https://www.rabbitmq.com/tutorials/tutorial-one-ruby

# RabbitMQ is a post box, a post office, and a letter carrier
# message - a letter
# producer - a sender
# queue name - a post box
# consumer - a receiver

# gem install bunny

require 'bunny'

connection = Bunny.new # (hostname: 'rabbit.local')
connection.start

channel = connection.create_channel
queue = channel.queue('hello') # idempotent action - it will only be created if it doesn't exist already
channel.default_exchange.publish('Hello World!', routing_key: queue.name) # by default [persistent: true]
puts " [x] Sent 'Hello World!'"

connection.close

# Tab 1
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/01_1_hello_world_sender.rb

# Tab 2
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/01_2_hello_world_receiver.rb
