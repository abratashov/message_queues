require 'bunny'

message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

connection = Bunny.new(
  automatically_recover: false
  # Default values:
  # host: 'localhost', # RabbitMQ server address
  # port: 5672,        # RabbitMQ server port
  # username: 'guest', # RabbitMQ username
  # password: 'guest', # RabbitMQ password
)

connection.start

channel = connection.create_channel

# This :durable option change needs to be applied to both the producer and consumer code.
queue = channel.queue('task_queue', durable: true)

channel.prefetch(1) # Balanced distribution: pushes only one message into the queue and waits ACK
puts ' [*] Waiting for messages. To exit press CTRL+C'

begin
  queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
    puts " [x] Received '#{body}'"
    # imitate some work
    sleep body.count('.').to_i
    puts ' [x] Done'
    channel.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  connection.close

  exit(0)
end
