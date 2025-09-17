from kafka import KafkaProducer
import json, time, random

producer = KafkaProducer(
    bootstrap_servers=["kafka:9092"],
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

while True:
    message = {
        "user_id": random.randint(1, 1000),
        "signup_time": time.strftime("%Y-%m-%d %H:%M:%S")
    }
    producer.send("user-signups", message)
    print("Produced:", message)
    time.sleep(2)
