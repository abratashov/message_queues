class ImportConsumer < Karafka::BaseConsumer
  def consume
    # payload = JSON.parse(messages.first.payload)  # Single message job
    payload = messages.first.payload  # Single message job
    ap "Starting import of #{payload['file']}"
    sleep(10)  # Simulate long processing (e.g., reading CSV, saving to DB)
    ap "Finished import of #{payload['file']}"
  end
end
