#  Kafka → ClickHouse Pipeline (Local Docker Setup)

This folder contains a **local version** of the real-time pipeline using **Docker Compose**.
It runs the following services:

* **Zookeeper** → Required by Kafka.
* **Kafka** → Message broker where events are published.
* **ClickHouse** → Database with Kafka Engine for real-time ingestion.
* **Producer** → Python app that generates mock user signup events.

---

## 📂 Folder Structure

```
docker/
├── docker-compose.yml
├── producer/
│   ├── producer.py
│   ├── requirements.txt
│   └── Dockerfile
└── clickhouse-init/
    └── init.sql
```

---

## ⚙️ How It Works

1. **Producer** pushes messages into Kafka topic `user-signups`.
2. **ClickHouse Kafka Engine Table** subscribes to the topic.
3. **Materialized View** auto-inserts data into `demo.user_signups` table.
4. You can query live data directly in ClickHouse.

---

## 🛠️ Steps to Run

1. **Clone repo & go into docker setup**

   ```bash
   git clone https://github.com/mohhddhassan/kafka-clickhouse-k8s.git
   cd kafka-clickhouse-pipeline/docker
   ```

2. **Start services**

   ```bash
   docker compose up -d
   ```

3. **Verify tables in ClickHouse**

   ```bash
   curl "http://localhost:8123/?query=SHOW+TABLES+FROM+demo"
   ```

   Expected output:

   ```
   kafka_signups
   user_signups
   signup_mv
   ```

4. **Check data flowing in**

   ```bash
   curl "http://localhost:8123/?query=SELECT+*+FROM+demo.user_signups+LIMIT+5"
   ```

   Example:

   ```
   123   2025-09-16 12:34:56
   456   2025-09-16 12:34:58
   ```

---

## 🛑 Stopping Services

```bash
docker compose down
```

---

## 📌 Notes

* Producer generates a random `user_id` every 2 seconds.
* `init.sql` runs automatically when ClickHouse starts, creating all required tables.
* This setup is **only for local testing**. For production-like deployment → check the `k8s/` folder.

---
