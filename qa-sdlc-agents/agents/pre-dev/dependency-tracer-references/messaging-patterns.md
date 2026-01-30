# Message Queue & Event Detection Patterns

## Glob Patterns for Locating Messaging Code

### Java
```
**/listener/**/*.java
**/listeners/**/*.java
**/consumer/**/*.java
**/consumers/**/*.java
**/producer/**/*.java
**/publishers/**/*.java
**/messaging/**/*.java
**/events/**/*.java
**/event/**/*.java
**/handler/**/*.java
**/handlers/**/*.java
**/config/*Rabbit*.java
**/config/*Kafka*.java
**/config/*Messaging*.java
**/config/*Queue*.java
```

### ASP.NET Core
```
**/Consumers/**/*.cs
**/Handlers/**/*.cs
**/Events/**/*.cs
**/Messaging/**/*.cs
**/Listeners/**/*.cs
**/Publishers/**/*.cs
**/Workers/**/*.cs
**/BackgroundServices/**/*.cs
```

### Node.js
```
**/consumers/**/*.{js,ts}
**/producers/**/*.{js,ts}
**/listeners/**/*.{js,ts}
**/events/**/*.{js,ts}
**/messaging/**/*.{js,ts}
**/workers/**/*.{js,ts}
**/queues/**/*.{js,ts}
**/subscribers/**/*.{js,ts}
```

### Python
```
**/consumers/**/*.py
**/producers/**/*.py
**/tasks/**/*.py
**/events/**/*.py
**/messaging/**/*.py
**/workers/**/*.py
**/celery/**/*.py
**/signals/**/*.py
```

---

## Grep Patterns by Messaging System

### RabbitMQ

**Java — Spring AMQP**:
```regex
@RabbitListener\s*\(
RabbitTemplate\.convertAndSend
RabbitTemplate\.convertSendAndReceive
@RabbitHandler
@Exchange|@Queue|@QueueBinding
spring\.rabbitmq\.(host|port|username)
```

**ASP.NET — MassTransit / RabbitMQ Client**:
```regex
IModel\.BasicPublish
IModel\.BasicConsume
IConnection\.CreateModel
AddMassTransit
UsingRabbitMq
cfg\.ReceiveEndpoint
IBus\.Publish
```

**Node.js — amqplib**:
```regex
amqplib|amqp\.connect
channel\.assertQueue
channel\.publish
channel\.sendToQueue
channel\.consume
channel\.ack
channel\.nack
```

**Python — pika**:
```regex
pika\.BlockingConnection
channel\.basic_publish
channel\.basic_consume
channel\.queue_declare
```

### Apache Kafka

**Java — Spring Kafka**:
```regex
@KafkaListener\s*\(
KafkaTemplate\.send
spring\.kafka\.(bootstrap-servers|consumer|producer)
ConsumerFactory|ProducerFactory
@EnableKafka
```

**ASP.NET — Confluent.Kafka**:
```regex
ProducerBuilder
ConsumerBuilder
IProducer<
IConsumer<
Confluent\.Kafka
\.Produce\(
\.Consume\(
\.Subscribe\(
```

**Node.js — kafkajs**:
```regex
Kafka\s*\(
producer\.send
consumer\.subscribe
consumer\.run
admin\.createTopics
```

**Python — confluent-kafka / kafka-python**:
```regex
confluent_kafka\.(Producer|Consumer)
KafkaProducer|KafkaConsumer
producer\.produce
consumer\.poll
```

### Azure Service Bus

**ASP.NET (primary)**:
```regex
ServiceBusClient
ServiceBusSender
ServiceBusReceiver
ServiceBusProcessor
ServiceBusSessionProcessor
\.SendMessageAsync
\.ProcessMessageAsync
AddAzureClients.*ServiceBus
```

**Java**:
```regex
ServiceBusClientBuilder
ServiceBusSenderClient
ServiceBusReceiverClient
ServiceBusProcessorClient
```

**Node.js**:
```regex
@azure/service-bus
ServiceBusClient
ServiceBusSender
ServiceBusReceiver
```

### AWS SQS / SNS

```regex
AmazonSQS|SqsClient|@aws-sdk/client-sqs
AmazonSNS|SnsClient|@aws-sdk/client-sns
SendMessageRequest|ReceiveMessageRequest
\.sendMessage\(|\.receiveMessage\(
PublishCommand|SendMessageCommand
```

### Redis Pub/Sub (as messaging)

```regex
\.subscribe\s*\(|\.publish\s*\(
redisClient\.subscribe
pubSub\.subscribe|pubSub\.publish
StackExchange\.Redis.*Subscriber
```

### Spring Cloud Stream

```regex
@EnableBinding
@StreamListener
@Input|@Output
spring\.cloud\.stream\.(bindings|binders)
```

---

## Topic / Queue Name Extraction

### From Annotations
```regex
@RabbitListener\s*\(\s*queues\s*=\s*"([^"]+)"
@KafkaListener\s*\(\s*topics\s*=\s*"([^"]+)"
```

### From Configuration
```regex
spring\.rabbitmq\..*queue.*=\s*(.+)
spring\.kafka\..*topic.*=\s*(.+)
spring\.cloud\.stream\.bindings\.(\w+)\.destination\s*=\s*(.+)
```

### From Code
```regex
channel\.assertQueue\s*\(\s*['"]([^'"]+)['"]
producer\.send\s*\(\s*\{\s*topic:\s*['"]([^'"]+)['"]
```

---

## Message Type / Schema Detection

### Java
```regex
class\s+\w+Event\s
class\s+\w+Message\s
class\s+\w+Command\s
record\s+\w+(Event|Message|Command)\s*\(
```

### ASP.NET
```regex
class\s+\w+Event\s*:
class\s+\w+Message\s*:
class\s+\w+Command\s*:
record\s+\w+(Event|Message|Command)
: INotification
: IRequest
```

### Node.js / Python
```regex
interface\s+\w+(Event|Message|Payload)
type\s+\w+(Event|Message|Payload)
class\s+\w+(Event|Message|Payload)
```

---

## Producer vs Consumer Classification

| Pattern | Role |
|---------|------|
| `Template.send`, `Template.convertAndSend` | **Producer** |
| `@RabbitListener`, `@KafkaListener` | **Consumer** |
| `channel.publish`, `channel.sendToQueue` | **Producer** |
| `channel.consume` | **Consumer** |
| `producer.send`, `Produce` | **Producer** |
| `consumer.subscribe`, `consumer.run`, `Consume` | **Consumer** |
| `IBus.Publish`, `SendMessageAsync` | **Producer** |
| `ProcessMessageAsync`, `ReceiveEndpoint` | **Consumer** |
