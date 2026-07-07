# Modern Data Engineering Pipeline with Kafka, Airflow, Snowflake & dbt

## Project Overview

This project demonstrates an end-to-end modern Data Engineering pipeline that captures real-time transactional data from PostgreSQL, streams it through Apache Kafka using Debezium CDC, stores raw data in a Data Lake (MinIO), orchestrates data movement with Apache Airflow, transforms data using dbt, and builds an analytical data warehouse in Snowflake.

The project follows modern Data Engineering best practices including Change Data Capture (CDC), incremental loading, Slowly Changing Dimensions (SCD Type 2), dimensional modeling, orchestration, CI/CD automation, and data quality validation.

---

## Architecture

```
                +----------------+
                | Faker Generator|
                +--------+-------+
                         |
                         v
                +----------------+
                | PostgreSQL OLTP|
                +--------+-------+
                         |
                   Debezium CDC
                         |
                         v
                +----------------+
                | Apache Kafka   |
                +--------+-------+
                         |
                  Kafka Consumer
                         |
                         v
                +----------------+
                | MinIO Data Lake|
                |  (Raw Layer)   |
                +--------+-------+
                         |
                  Apache Airflow
                         |
                         v
                +----------------+
                | Snowflake RAW  |
                +--------+-------+
                         |
                       dbt
                         |
        +----------------+----------------+
        |                                 |
        v                                 v
   Staging Models                 Snapshot Models
                                         |
                                         v
                                  SCD Type 2
                                         |
                                         v
                          Star Schema (Dimensions & Facts)
```

---

## Technologies Used

* Python
* PostgreSQL
* Apache Kafka
* Debezium
* Apache Zookeeper
* MinIO (S3 Compatible Data Lake)
* Apache Airflow
* Snowflake
* dbt
* Docker & Docker Compose
* GitHub Actions (CI/CD)
* Git
* Faker

---

## Project Features

### Data Generation

A Python application continuously generates synthetic e-commerce data using Faker.

Generated entities include:

* Customers
* Employees
* Stores
* Products
* Inventory
* Sales
* Reviews

---

### Change Data Capture (CDC)

Debezium monitors PostgreSQL transaction logs and publishes every INSERT, UPDATE, and DELETE event to Kafka topics in real time.

---

### Kafka Streaming

Each database table has its own Kafka topic.

Example:

* ecommerce_server.public.customers
* ecommerce_server.public.products
* ecommerce_server.public.sales

---

### Data Lake

A Kafka Consumer application reads Kafka topics and stores data as Parquet files inside MinIO.

Storage structure:

```
raw/
    customers/
    products/
    sales/
    inventory/
    reviews/
    stores/
    employee/
```

---

### Airflow Orchestration

Airflow automates the data pipeline by:

* Downloading Parquet files from MinIO
* Loading raw data into Snowflake
* Executing dbt transformations
* Running dbt Snapshots
* Building analytical marts

---

### dbt Transformations

The dbt project includes:

* Staging models
* Source definitions
* Snapshots (SCD Type 2)
* Incremental Fact tables
* Dimension tables
* Data Tests

---

### Dimensional Modeling

Dimensions:

* dim_customers
* dim_products
* dim_stores
* dim_employee

Facts:

* fct_sales
* fct_reviews

---

### CI/CD

GitHub Actions automatically executes:

* Ruff (Python linting)
* Pytest
* dbt deps
* dbt debug
* dbt compile
* dbt test

Deployment workflow executes:

* dbt run
* dbt test

---

## Repository Structure

```
.
├── airflow/
├── consumer/
├── docker/
├── ecommerce_dbt/
│   ├── models/
│   ├── snapshots/
│   ├── macros/
│   ├── tests/
│   └── dbt_project.yml
├── producer/
├── scripts/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── cd.yml
├── docker-compose.yml
├── requirements.txt
└── README.md
```

---

## How to Run

### Clone repository

```bash
git clone https://github.com/younes9888/ecommerce-modern-datastack.git

cd ecommerce-modern-datastack
```

### Start the platform

```bash
docker compose up -d
```

### Generate fake data

```bash
python producer/faker-data-generator.py
```

### Create Debezium Connector

```bash
python producer/generate_connector.py
```

### Start Kafka Consumer

```bash
python consumer/kafka_To_MinIo.py
```

### Execute dbt

```bash
cd ecommerce_dbt

dbt deps

dbt run

dbt snapshot

dbt test
```

---

## Data Pipeline Layers

### Bronze Layer

Raw Parquet files stored in MinIO.

### Silver Layer

Staging models created using dbt.

### Gold Layer

Business-ready dimensional models built inside Snowflake.

---

## Learning Objectives

This project demonstrates practical experience with:

* Data Engineering
* CDC Pipelines
* Event Streaming
* Data Warehouse Design
* Star Schema Modeling
* Slowly Changing Dimensions (Type 2)
* Incremental Data Processing
* Workflow Orchestration
* CI/CD Automation

---

## Author

**Younes ZIAT**

Data Engineering Portfolio Project

GitHub: https://github.com/younes9888
