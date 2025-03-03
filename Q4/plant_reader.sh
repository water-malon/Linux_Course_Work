#!/bin/bash

# Get the absolute path of the CSV file
CSV_PATH=$(realpath "my_plant.csv")

# Check if the file exists
if [ ! -f "$CSV_PATH" ]; then
    echo "File does not exist: $CSV_PATH" | tee -a script.log
    exit 1
fi

# Print the absolute path
echo "The absolute path of the CSV file is: $CSV_PATH" | tee -a script.log

# Define the directory for the virtual environment
VENV_DIR="../env"

# Create a new virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..." | tee -a script.log
    python3 -m venv "$VENV_DIR"
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Install required packages
pip install --upgrade pip | tee -a script.log
pip install matplotlib pandas | tee -a script.log

# Run the plant.py script with the CSV file
echo "Running plant.py with $CSV_PATH" | tee -a script.log
if python3 plant.py "$CSV_PATH"; then
    echo "Python script ran successfully." | tee -a script.log
else
    echo "Python script encountered an error." | tee -a script.log
    deactivate
    exit 1
fi

# Deactivate the virtual environment
deactivate

echo "Script completed successfully." | tee -a script.log