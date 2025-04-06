# Topics
# https://www.rabbitmq.com/tutorials/tutorial-five-ruby

# In our logging system we might want to subscribe to not only logs based on severity,
# but also based on the source which emitted the log.
# You might know this concept from the syslog unix tool,
# which routes logs based on both severity (info/warn/crit...) and facility (auth/cron/kern...).

# That would give us a lot of flexibility - we may want to listen to just critical errors coming from 'cron'
# but also all logs from 'kern'.

# Examples: "stock.usd.nyse", "nyse.vmw", "quick.orange.rabbit".
# There can be as many words in the routing key as you like, up to the limit of 255 bytes.

# The first word in the routing key will describe speed, second a colour and third a species: "<speed>.<colour>.<species>".
# We created three bindings: Q1 is bound with binding key "*.orange.*" and Q2 with "*.*.rabbit" and "lazy.#".
# * (star) can substitute for exactly one word.
# # (hash) can substitute for zero or more words.

# |Q1                         |Q2
# |*.orange.*                 |*.*.rabbit                 |lazy.#
# |---------------------------|---------------------------|--------------------
# |quick.orange.rabbit        |quick.orange.rabbit        |
# |lazy.orange.elephant       |                           |lazy.orange.elephant
# |quick.orange.fox           |                           |
# |                           |                           |lazy.brown.fox
# |                           |                           |lazy.pink.rabbit
# |                           |                           |lazy.orange.new.rabbit

# NOT MATCH:
#   quick.brown.fox
#   orange
#   quick.orange.new.rabbit

# Binding to '#' === fanout
# Without '*' or '#', topic ex. === direct ex.

require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.topic('topic_logs')

severity = ARGV.shift || 'anonymous.info' # Pattern: <facility>.<severity>
message = ARGV.empty? ? 'Hello World!' : ARGV.join(' ')

exchange.publish(message, routing_key: severity)
puts " [x] Sent #{severity}:#{message}"

connection.close

# Tab 1
# And to emit a log with a routing key "kern.critical" type:
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_1_topic_sender.rb "kern.critical" "A critical kernel error"
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_1_topic_sender.rb "kern.info" "A critical kernel error"
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_1_topic_sender.rb "s1.critical" "A critical kernel error"
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_1_topic_sender.rb "s2.error" "A critical kernel error"

# Tab 2
# To receive all the logs:
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_2_topic_receiver.rb "#"

# Tab 3
# To receive all logs from the facility "kern":
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_2_topic_receiver.rb "kern.*"

# Tab 4
# To receive critical logs:
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_2_topic_receiver.rb "*.critical"

# Tab 5
# To create multiple bindings:
# ruby /home/alex/Dropbox/MyDB/Work/RabbitMQ/05_2_topic_receiver.rb "kern.*" "*.critical"
