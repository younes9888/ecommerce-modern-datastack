import os 
import json
import requests
from dotenv import load_dotenv

load_dotenv()

connector_config = {
    "name": "postgres-connector",
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": os.getenv("POSTGRES_HOST"),
        "database.port": os.getenv("POSTGRES_PORT"),
        "database.user": os.getenv("POSTGRES_USER"),
        "database.password": os.getenv("POSTGRES_PASSWORD"),
        "database.dbname": os.getenv("POSTGRES_DB"),       
        "topic.prefix": "ecommerce_server",
        "table.include.list": "public.customers,public.employee,public.stores,public.products,public.sales,public.reviews,public.inventory",
        "plugin.name": "pgoutput",
        "slot.name": "debezium_slot",
        "publication.auto.create.mode": "filtered",
        "tombstones.on.delete": "false",
        "decimal.handling.mode": "double",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "schema.history.internal.kafka.topic": "schema-changes.ecommerce",
    },
}

url = "http://localhost:8083/connectors"
headers = {"Content-Type": "application/json"}

response = requests.post(url, headers=headers, data=json.dumps(connector_config))

if response.status_code == 201:
    print("Connector created successfully!")
elif response.status_code == 409:
    print("Connector already exists.")  
else:
    print(f"Failed to create connector. ({response.status_code}) {response.text}")

