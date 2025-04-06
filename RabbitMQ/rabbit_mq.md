# RabbitMQ

## ChatGPT

### Intro

RabbitMQ is a popular open-source message broker. It facilitates communication between different parts of a system by managing message queues. RabbitMQ enables applications to send and receive messages asynchronously, making it easier to build scalable and reliable systems.

It supports multiple messaging protocols, including AMQP (Advanced Message Queuing Protocol), which is its primary protocol. RabbitMQ handles various messaging patterns, such as publish/subscribe, request/reply, and point-to-point messaging.

It's widely used in distributed systems for tasks like task scheduling, event broadcasting, and load balancing. You can use it to decouple different parts of an application, ensuring that they can operate independently and even handle varying workloads.

### Architecture solutions

Here are a few examples of how RabbitMQ can be used:

**Task Queueing**: Suppose you have a web application where users upload files for processing, like image resizing or video encoding. The web server can place the file processing tasks in a RabbitMQ queue. Worker processes can then pick up tasks from the queue and handle them, which helps to balance the load and avoid overloading the web server.

**Microservices Communication**: In a microservices architecture, different services need to communicate with each other. RabbitMQ can be used to send messages between services, such as order processing, payment processing, and inventory management. This setup allows for loose coupling, as each service can operate independently.

**Real-Time Notifications**: In a system that provides real-time updates, like a chat application or a live sports score service, RabbitMQ can be used to distribute messages to multiple recipients. For example, when a user sends a message in a chat room, the message can be published to a RabbitMQ exchange, which then distributes it to all connected users.

**Data Streaming**: RabbitMQ can be used for streaming data from one part of a system to another. For example, a sensor network could send data to a central server via RabbitMQ, where the data is then processed and stored.

**Event-Driven Systems**: In systems that react to specific events, RabbitMQ can be used to trigger actions. For instance, in an e-commerce platform, when a user makes a purchase, an event can be published to RabbitMQ. This event can then trigger processes like updating inventory, sending a confirmation email, and logging the transaction.

### Examples of Apps

Here are a few real-life examples of applications and services that use RabbitMQ:

**Instagram**: Instagram uses RabbitMQ to handle the high volume of notifications and updates, such as likes, comments, and new followers. It helps in distributing these events to different parts of their system for processing.

**Pinterest**: Pinterest uses RabbitMQ to manage the communication between different services, such as user notifications and feed updates. It helps ensure that messages are delivered efficiently and reliably across their infrastructure.

**Mozilla**: The Mozilla Firefox team uses RabbitMQ for telemetry data collection and processing. They gather data from user interactions and send it to their servers for analysis, helping them improve the browser.

**WeWork**: WeWork, the office space company, uses RabbitMQ to handle real-time updates and communication between different parts of their digital infrastructure, such as booking systems and membership management.

**SoundCloud**: SoundCloud uses RabbitMQ to manage the flow of data between different services, including notifications and updates about user activity, like uploads and comments.

### Example: Instagram's architecture

Let's imagine a simplified version of Instagram's architecture using RabbitMQ for handling notifications:

**User Actions**: When a user performs an action, like liking a photo, following another user, or posting a comment, these actions generate events. These events are sent to a RabbitMQ exchange, which is responsible for routing the messages to the appropriate queues.

**RabbitMQ Exchange**: The exchange receives the events and routes them based on predefined rules or bindings. For example, different types of notifications (likes, comments, follows) may be routed to different queues, or all notifications for a particular user might go to the same queue.

**Notification Queues**: There can be multiple queues in RabbitMQ, each representing a different type of notification or a different user. For instance:

**Likes Queue**: For notifications related to likes on photos.
* **Comments Queue**: For notifications related to comments.
* **Follows Queue**: For notifications related to new followers.
* **User Notification Queues**: For aggregating all notifications specific to a user.
* **Worker Processes**: These are servers or services that consume messages from the RabbitMQ queues. They process the messages and perform actions such as updating the user's notification feed, sending push notifications to mobile devices, or updating activity logs.

**Notification Delivery**: Once the worker processes handle the messages, the notifications are sent to users. This could involve updating the app's notification tab, sending push notifications, or triggering other events like emails.

**Scalability and Load Balancing**: RabbitMQ helps manage the load by distributing messages across multiple queues and worker processes. This ensures that the system can handle a large number of user actions simultaneously without becoming overwhelmed.

For example, when User A likes User B's photo:

* The like event is sent to RabbitMQ.
* The exchange routes the event to the Likes Queue.
* A worker process picks up the message from the Likes Queue.
* The worker updates User B's notification feed and sends a push notification to User B's device.

### Example: Order Service and Inventory Service

Let's consider a hypothetical e-commerce platform with two microservices: Order Service and Inventory Service. RabbitMQ will be used to facilitate communication between these services.

**Order Service**: This service handles order processing. When a user places an order, the Order Service validates the order details, processes payment, and generates an order confirmation.

**RabbitMQ Exchange**: The Order Service publishes an event to RabbitMQ when an order is successfully placed. This event includes information such as the order ID, the items ordered, and their quantities.

**Exchange and Routing**: The RabbitMQ exchange receives the order event and routes it based on the event type. In this case, it routes the message to a queue that the Inventory Service listens to, known as the Order Events Queue.

**Order Events Queue**: This queue holds messages related to order events. It serves as a buffer that decouples the Order Service from the Inventory Service, ensuring that even if the Inventory Service is temporarily down, the messages will not be lost and can be processed later.

**Inventory Service**: The Inventory Service is subscribed to the Order Events Queue. It consumes messages from this queue to update inventory levels. For each order message, it decrements the stock levels of the ordered items.

**Notification or Acknowledgment**: After successfully updating the inventory, the Inventory Service can optionally publish an acknowledgment message back to another RabbitMQ queue, which the Order Service might be subscribed to. This lets the Order Service know that the inventory has been updated successfully, and it can proceed with any additional post-order tasks (like sending a confirmation email to the user).

Flow Summary
* User places an order through the Order Service.
* The Order Service publishes an order event to the RabbitMQ exchange.
* The exchange routes the event to the Order Events Queue.
* The Inventory Service consumes the message from the Order Events Queue.
* The Inventory Service updates the stock levels and can optionally send an acknowledgment back to the Order Service.

### RabbitMQ limitations

**Message Storage Duration**

* By default, RabbitMQ stores messages in queues until they are consumed or explicitly deleted. However, you can configure message TTL (Time-To-Live) to automatically remove messages after a certain period.
* If persistent messages are stored and not consumed, they can accumulate and potentially fill up disk space, leading to system issues.

**Capacity and Volume**

* The capacity for storing messages in RabbitMQ depends on the resources of the host machine, including RAM and disk space. RabbitMQ can use RAM for faster message delivery and disk for persistence. The amount of data it can store isn't fixed; it depends on the hardware and configuration.
* For persistent messages, the size of messages that can be stored is limited by the disk space available on the server. RabbitMQ supports clustering, which can distribute the load across multiple machines, thereby increasing capacity.
* The actual message size is typically limited by the memory available to RabbitMQ and the Erlang VM's configuration. The size of a single message can be limited by the maximum frame size, which is configurable. The default frame size is 128 MB, but it can be increased if necessary.

**Performance Considerations**

* As the number of messages in a queue grows, performance may degrade, especially for operations like queue inspection and message retrieval.
* RabbitMQ is designed to handle high throughput, but large messages or very large numbers of messages can affect its performance. It's recommended to keep message sizes small and process them promptly.

**Clustering and High Availability**

* While RabbitMQ supports clustering for scalability and high availability, managing large clusters can become complex. Network partitions or failures can cause issues with message synchronization and consistency.
* In high-availability (HA) setups, queues can be mirrored across multiple nodes, which helps with failover. However, this also means that the storage requirements and network usage increase, as messages need to be replicated.

**Data Consistency**

* RabbitMQ prioritizes availability over strict consistency. This means that in certain failure scenarios, there could be temporary inconsistencies, such as message duplication.

**Message Size Limits**

* There is no strict limit on message size, but large messages can consume significant memory and disk resources. It's generally recommended to keep messages small and use other methods, like storing large payloads in a separate storage system (like a database or file system) and passing references in RabbitMQ messages.

## Resources

```sh
# Installation https://www.rabbitmq.com/install-debian.html
sudo apt-get install rabbitmq-server
sudo service rabbitmq-server start
sudo journalctl --system | grep rabbitmq
sudo rabbitmq-plugins enable rabbitmq_management

http://localhost:15672/
guest/guest

sudo rabbitmqctl list_queues
sudo rabbitmqctl environment

sudo rabbitmqctl eval 'application:set_env(rabbit, consumer_timeout, 36000000).'
sudo rabbitmqctl eval 'application:get_env(rabbit, consumer_timeout).'
sudo rabbitmqctl list_queues name messages_ready messages_unacknowledged

sudo rabbitmqctl list_exchanges
sudo rabbitmqctl list_bindings

# https://www.rabbitmq.com/docs/cli#authentication
sudo rabbitmqctl add_user mquser mqpassword2#mdF5dv@
# Give the user full access to the default virtual host (/)
sudo rabbitmqctl set_permissions -p / mquser ".*" ".*" ".*"
# Assign Administrator Tag
sudo rabbitmqctl set_user_tags mquser administrator

```

## Examples

Pub/Sub

```rb
# Send
queue.subscribe(block: true) { |_delivery_info, _properties, body| '...' }

# Receive
channel.default_exchange.publish('Hello World!', routing_key: queue.name)
```

# Ruby Libs
https://github.com/ruby-amqp/bunny
http://rubybunny.info/articles/getting_started.html
https://github.com/jondot/sneakers
https://github.com/Beetrack/bunny_subscriber
https://github.com/mperham/connection_pool
https://github.com/ruby-amqp/hutch
https://puzzleflow.github.io/tochtli/
