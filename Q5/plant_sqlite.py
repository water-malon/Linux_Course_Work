import sqlite3
import matplotlib.pyplot as plt
import os

# Ensure the output folder exists
output_folder = "4_2"
os.makedirs(output_folder, exist_ok=True)

# Connect to SQLite database
db_path = sys.argv[1]
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# Fetch data from the database
cursor.execute("SELECT * FROM plants")
rows = cursor.fetchall()

# Process data
for row in rows:
    plant_id, date_collected, species, sex, weight = row
    height_data = list(map(float, row[1].split()))
    leaf_count_data = list(map(int, row[2].split()))
    dry_weight_data = list(map(float, row[3].split()))

    # Create plots as in the previous script
    # ...

conn.close()