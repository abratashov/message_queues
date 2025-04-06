# Work Queues
# https://www.rabbitmq.com/tutorials/tutorial-two-ruby

# The main idea behind Work Queues (aka: Task Queues) is to avoid doing a resource-intensive task immediately
# and having to wait for it to complete.
# Instead we schedule the task to be done later.
# We encapsulate a task as a message and send it to a queue.

require 'bunny'

connection = Bunny.new(automatically_recover: false)

connection.start

channel = connection.create_channel
# This :durable option change needs to be applied to both the producer and consumer code.
queue = channel.queue('task_queue', durable: true)

message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

queue.publish(message, persistent: true)
puts " [x] Sent #{message}"

connection.close

# Default RabbitBQ round-robin message processing
# Message acknowledgments are turned off by default
# 30 minutes timeout by default (consumer_timeout = 1800000 or 30 minutes in milliseconds)
# sudo rabbitmqctl eval 'application:set_env(rabbit, consumer_timeout, 36000000).'
# sudo rabbitmqctl eval 'application:get_env(rabbit, consumer_timeout).'


# Tab 1
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_2_worker.rb

# Tab 2
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_2_worker.rb

# Tab 3
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 1 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 2 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 3 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 4 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 5 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 6 ...
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/02_1_task.rb Message 7 .....  .....  .....
