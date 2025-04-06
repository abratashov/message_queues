# Publish/Subscribe
# https://www.rabbitmq.com/tutorials/tutorial-three-ruby

# We'll deliver a message to multiple consumers.
# This pattern is known as "publish/subscribe".

# To illustrate the pattern, we're going to build a simple logging system.
# It will consist of two programs -- the first will emit log messages and the second will receive and print them.

# In our logging system every running copy of the receiver program will get the messages.
# That way we'll be able to run one receiver and direct the logs to disk;
# and at the same time we'll be able to run another receiver and see the logs on the screen.

# Essentially, published log messages are going to be broadcast to all the receivers.

# MESSAGE => EXCHANGE => QUEUE => RECEIVER [MEQR]

# There are a few exchange types available:
# * direct
# * topic
# * headers
# * fanout

require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.fanout('logs')

message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message)
puts " [x] Sent #{message}"

connection.close

# Tab 1
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/03_1_pub_sub_log_emitter.rb Message 1 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/03_1_pub_sub_log_emitter.rb Message 1 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/03_1_pub_sub_log_emitter.rb Message 1 ...

# Tab 2
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/03_3_pub_sub_log_receiver_file.rb ~/Desktop/logger.log

# Tab 3
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/03_2_pub_sub_log_receiver_cmd.rb
