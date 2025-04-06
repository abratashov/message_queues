class ActivityConsumer < Karafka::BaseConsumer
  def consume
    messages.each do |message|
      # activity = JSON.parse(message.payload)
      activity = message.payload
      puts "[Partition #{message.partition}] Processed activity: #{activity['user_id']} - #{activity['action']}"
    end
  end
end
