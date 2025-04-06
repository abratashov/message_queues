# Remote procedure call (RPC)
# https://www.rabbitmq.com/tutorials/tutorial-six-ruby

# In this tutorial we're going to use RabbitMQ to build an RPC system: a client and a scalable RPC server.
# As we don't have any time-consuming tasks that are worth distributing,
# we're going to create a dummy RPC service that returns Fibonacci numbers.

# Although RPC is a pretty common pattern in computing, it's often criticised.
# The problems arise when a programmer is not aware whether a function call is local or if it's a slow RPC.
# Confusions like that result in an unpredictable system and adds unnecessary complexity to debugging.
# Instead of simplifying software, misused RPC can result in unmaintainable spaghetti code.

# We're going to set it to a unique value for every request.
# Later, when we receive a message in the callback queue we'll look at this property,
# and based on that we'll be able to match a response with a request.
# If we see an unknown :correlation_id value, we may safely discard the message - it doesn't belong to our requests.

require 'bunny'

class FibonacciServer
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
  end

  def start(queue_name)
    @queue = channel.queue(queue_name)
    @exchange = channel.default_exchange
    subscribe_to_queue
  end

  def stop
    channel.close
    connection.close
  end

  def loop_forever
    # This loop only exists to keep the main thread
    # alive. Many real world apps won't need this.
    loop { sleep 5 }
  end

  private

  attr_reader :channel, :exchange, :queue, :connection

  def subscribe_to_queue
    queue.subscribe do |_delivery_info, properties, payload|
      puts " [x] Get #{payload}"
      result = fibonacci(payload.to_i)
      puts " [x] => #{result}"

      exchange.publish(
        result.to_s,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )
    end
  end

  def fibonacci(value)
    return value if value.zero? || value == 1

    fibonacci(value - 1) + fibonacci(value - 2)
  end
end

begin
  server = FibonacciServer.new

  puts ' [x] Awaiting RPC requests'
  server.start('rpc_queue')
  server.loop_forever
rescue Interrupt => _
  server.stop
end

# Tab 1
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/06_1_rpc_server.rb

# Tab 2
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/06_1_rpc_server.rb

# Tab 3
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/06_2_rpc_client.rb 30

# Tab 4
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/06_2_rpc_client.rb 35
