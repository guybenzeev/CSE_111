"""Create the StockFlow schema and load the sample data.

Usage (from the repo root or the Database folder):
    python Database/seed_db.py                 # -> Database/stockflow.sqlite3
    python Database/seed_db.py path/to/other.db

Safe to re-run: the schema uses CREATE TABLE IF NOT EXISTS and the seed
script clears existing rows before inserting.
"""

import sqlite3
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
SCHEMA = HERE / "create_schema.sql"
SEED = HERE / "seed_data.sql"
TABLES = [
    "Category", "Product", "Supplier", "Warehouse", "Customer", "Orders",
    "Delivery", "ProductStock", "OrderLineItem", "SupplierProduct", "DeliveryItem",
]


def main() -> None:
    db_path = Path(sys.argv[1]) if len(sys.argv) > 1 else HERE / "stockflow.sqlite3"

    conn = sqlite3.connect(db_path)
    try:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.executescript(SCHEMA.read_text(encoding="utf-8"))
        conn.executescript(SEED.read_text(encoding="utf-8"))

        print(f"Seeded {db_path}")
        for table in TABLES:
            count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
            print(f"  {table:<16} {count:>3} rows")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
