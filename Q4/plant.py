import pandas as pd
import matplotlib.pyplot as plt
import os
import sys

# Ensure the output folder exists
output_folder = "4_2"
os.makedirs(output_folder, exist_ok=True)

# Read the CSV file path from command line arguments
csv_path = sys.argv[1]
data = pd.read_csv(csv_path)

# Iterate through each plant and generate plots
for index, row in data.iterrows():
    plant = row['Plant']
    height_data = list(map(float, row['Height'].split()))
    leaf_count_data = list(map(int, row['Leaf Count'].split()))
    dry_weight_data = list(map(float, row['Dry weight'].split()))

    # Print out the plant data (optional)
    print(f"Plant: {plant}")
    print(f"Height data: {height_data} cm")
    print(f"Leaf count data: {leaf_count_data}")
    print(f"Dry weight data: {dry_weight_data} g")

    # Create a directory for each plant
    plant_folder = os.path.join(output_folder, plant)
    os.makedirs(plant_folder, exist_ok=True)

    # Scatter Plot - Height vs Leaf Count
    plt.figure(figsize=(10, 6))
    plt.scatter(height_data, leaf_count_data, color='b')
    plt.title(f'Height vs Leaf Count for {plant}')
    plt.xlabel('Height (cm)')
    plt.ylabel('Leaf Count')
    plt.grid(True)
    plt.savefig(os.path.join(plant_folder, f"{plant}_scatter.png"))
    plt.close()  # Close the plot to prepare for the next one

    # Histogram - Distribution of Dry Weight
    plt.figure(figsize=(10, 6))
    plt.hist(dry_weight_data, bins=5, color='g', edgecolor='black')
    plt.title(f'Histogram of Dry Weight for {plant}')
    plt.xlabel('Dry Weight (g)')
    plt.ylabel('Frequency')
    plt.grid(True)
    plt.savefig(os.path.join(plant_folder, f"{plant}_histogram.png"))
    plt.close()  # Close the plot to prepare for the next one

    # Line Plot - Plant Height Over Time
    weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5']  # Time points for the data
    if len(height_data) == len(weeks):
        plt.figure(figsize=(10, 6))
        plt.plot(weeks, height_data, marker='o', color='r')
        plt.title(f'{plant} Height Over Time')
        plt.xlabel('Week')
        plt.ylabel('Height (cm)')
        plt.grid(True)
        plt.savefig(os.path.join(plant_folder, f"{plant}_line_plot.png"))
        plt.close()  # Close the plot

    # Output confirmation
    print(f"Generated plots for {plant}:")
    print(f"Scatter plot saved as {plant}_scatter.png")
    print(f"Histogram saved as {plant}_histogram.png")
    if len(height_data) == len(weeks):
        print(f"Line plot saved as {plant}_line_plot.png")