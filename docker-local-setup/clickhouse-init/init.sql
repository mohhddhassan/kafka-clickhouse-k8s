CREATE DATABASE IF NOT EXISTS demo;

-- Kafka Engine table (acts as a consumer)
CREATE TABLE IF NOT EXISTS demo.kafka_signups (
    user_id UInt32,
    signup_time String
) ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'user-signups',
    kafka_group_name = 'clickhouse-group',
    kafka_format = 'JSONEachRow';

-- Final table
CREATE TABLE IF NOT EXISTS demo.user_signups (
    user_id UInt32,
    signup_time String
) ENGINE = MergeTree()
ORDER BY user_id;

-- Materialized View (auto insert into final table)
CREATE MATERIALIZED VIEW IF NOT EXISTS demo.signup_mv
TO demo.user_signups
AS SELECT * FROM demo.kafka_signups;
