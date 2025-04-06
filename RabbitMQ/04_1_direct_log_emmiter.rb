# Routing
# https://www.rabbitmq.com/tutorials/tutorial-four-ruby

# We're going to make it possible to subscribe only to a subset of the messages.
# For example, we will be able to direct only critical error messages to the log file (to save disk space),
# while still being able to print all of the log messages on the console.

require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.direct('direct_logs')
severity = ARGV.shift || 'info'
message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message, routing_key: severity)
puts " [x] Sent '#{message}'"

connection.close

# Tab 1
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/04_1_direct_log_emmiter.rb error Message 1 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/04_1_direct_log_emmiter.rb info Message 2 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/04_1_direct_log_emmiter.rb warning Message 3 ...

# Tab 2
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/04_2_direct_log_receiver.rb error

# Tab 3
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/04_2_direct_log_receiver.rb error info warning

