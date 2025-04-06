require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.fanout('logs')
queue = channel.queue('', exclusive: true) # => create a non-durable queue with a generated name 'amq.gen-JzTY20BRgKO-HjmUJj0wLg'

queue.bind(exchange) # That relationship between exchange and a queue is called a binding

puts ' [*] Waiting for logs. To exit press CTRL+C'

begin
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] #{body}"
  end
rescue Interrupt => _
  channel.close
  connection.close
end
