import time
import psycopg2
from faker import Faker
import random
import argparse
import sys
import os
from dotenv import load_dotenv

load_dotenv()

# -----------------------------
# Config
# -----------------------------
NUM_CUSTOMERS = 20
NUM_EMPLOYEES = 10
NUM_STORES = 3
NUM_PRODUCTS = 15
NUM_SALES = 50
NUM_REVIEWS = 40
NUM_INVENTORY_LINES = 20

DEFAULT_LOOP = True
SLEEP_SECONDS = 2

parser = argparse.ArgumentParser()
parser.add_argument("--once", action="store_true")
args = parser.parse_args()
LOOP = not args.once and DEFAULT_LOOP

fake = Faker()

# -----------------------------
# DB connection
# -----------------------------
conn = psycopg2.connect(
    host=os.getenv("POSTGRES_HOST"),
    port=os.getenv("POSTGRES_PORT"),
    dbname=os.getenv("POSTGRES_DB"),
    user=os.getenv("POSTGRES_USER"),
    password=os.getenv("POSTGRES_PASSWORD"),
)
conn.autocommit = True
cur = conn.cursor()

# -----------------------------
# helpers
# -----------------------------
def rand_price():
    return round(random.uniform(5, 500), 2)

# -----------------------------
# core logic
# -----------------------------
def run_iteration():

    customers = []
    employees = []
    stores = []
    products = []

    # 1. STORES
    for _ in range(NUM_STORES):
        name = fake.company()
        city = fake.city()

        cur.execute(
            "INSERT INTO stores (store_name, city) VALUES (%s, %s) RETURNING id",
            (name, city),
        )
        stores.append(cur.fetchone()[0])

    # 2. CUSTOMERS
    for _ in range(NUM_CUSTOMERS):
        cur.execute(
            "INSERT INTO customers (first_name, last_name, email) VALUES (%s, %s, %s) RETURNING id",
            (fake.first_name(), fake.last_name(), fake.unique.email()),
        )
        customers.append(cur.fetchone()[0])

    # 3. EMPLOYEES
    for store_id in stores:
        for _ in range(NUM_EMPLOYEES // NUM_STORES):
            cur.execute(
                """
                INSERT INTO employee (store_id, first_name, last_name, role)
                VALUES (%s, %s, %s, %s)
                RETURNING id
                """,
                (
                    store_id,
                    fake.first_name(),
                    fake.last_name(),
                    random.choice(["Cashier", "Manager", "Stock Clerk"]),
                ),
            )
            employees.append(cur.fetchone()[0])

    # 4. PRODUCTS
    for _ in range(NUM_PRODUCTS):
        cur.execute(
            """
            INSERT INTO products (product_name, category, price)
            VALUES (%s, %s, %s)
            RETURNING id
            """,
            (
                fake.word().capitalize(),
                random.choice(["Electronics", "Food", "Clothing", "Home"]),
                rand_price(),
            ),
        )
        products.append(cur.fetchone()[0])

    # 5. INVENTORY
    for store_id in stores:
        for product_id in products:
            cur.execute(
                """
                INSERT INTO inventory (store_id, product_id, quantity)
                VALUES (%s, %s, %s)
                """,
                (store_id, product_id, random.randint(0, 100)),
            )

    # 6. SALES
    for _ in range(NUM_SALES):
        cur.execute(
            """
            INSERT INTO sales (customer_id, product_id, store_id, quantity, total_amount)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (
                random.choice(customers),
                random.choice(products),
                random.choice(stores),
                random.randint(1, 5),
                rand_price(),
            ),
        )

    # 7. REVIEWS
    for _ in range(NUM_REVIEWS):
        cur.execute(
            """
            INSERT INTO reviews (customer_id, product_id, rating, comment)
            VALUES (%s, %s, %s, %s)
            """,
            (
                random.choice(customers),
                random.choice(products),
                random.randint(1, 5),
                fake.sentence(),
            ),
        )

    print(
        f"✅ Generated: "
        f"{len(customers)} customers, "
        f"{len(employees)} employees, "
        f"{len(stores)} stores, "
        f"{len(products)} products, "
        f"{NUM_SALES} sales, "
        f"{NUM_REVIEWS} reviews"
    )

# -----------------------------
# loop
# -----------------------------
try:
    i = 0
    while True:
        i += 1
        print(f"\n--- Iteration {i} ---")
        run_iteration()
        if not LOOP:
            break
        time.sleep(SLEEP_SECONDS)

except KeyboardInterrupt:
    print("Stopped.")

finally:
    cur.close()
    conn.close()
    sys.exit(0)