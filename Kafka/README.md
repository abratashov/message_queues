# Karafka Basics

## Run

```sh
# Tab 1
cd ~/projects/abratashov/message_queues/Kafka
docker-compose up -d
# to shutdown if permission denied error:
docker stop kafka zookeeper
# or
docker exec -it kafka kill 1
docker exec -it zookeeper kill 1
docker container prune

cd ~/projects/abratashov/message_queues/Kafka/karafka-example
bundle exec karafka server

# Tab 2
cd ~/projects/abratashov/message_queues/Kafka/karafka-example
bundle exec karafka-web install
# bundle exec karafka-web install --replication-factor 1
bundle exec puma
# http://localhost:9292/

# Tab 3
cd ~/projects/abratashov/message_queues/Kafka/karafka-example
ruby producer.rb
```

# Processing messages

Imagine your `ImportConsumer` processes messages from a topic:

* Karafka polls for messages, waiting up to `max_wait_time` (1s) to fetch a batch.
* It processes the batch, which must finish within `kafka.max.poll.interval.ms` (5m) to avoid rebalancing.
* Every 5 seconds (`kafka.topic.metadata.refresh.interval.ms`), it refreshes metadata.
* If an error occurs, Karafka pauses the partition for `pause_timeout` (1s), then increases the pause up to `pause_max_timeout` (30s) with `pause_with_exponential_backoff`.
