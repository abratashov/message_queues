# Install Kafka

## Karafka Basics

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
