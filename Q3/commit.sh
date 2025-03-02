#!/bin/bash

# Ensure the CSV file exists
CSV_FILE="DevBug.csv"
if [[ ! -f "$CSV_FILE" ]]; then
    echo "CSV file '$CSV_FILE' not found!"
    exit 1
fi

# Read the required data from the CSV file using awk
data=$(awk -F',' 'NR==2 {print "BugID:" $1 ":CurrentDateTime::BranchName:" $3 ":DevName:" $4 ":Priority:" $5 ":ExcelDescription:" $2}' "$CSV_FILE")

# Get current date and time
CURRENT_DATE_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Append current date and time to the data
COMMIT_MESSAGE=$(echo $data | sed "s/CurrentDateTime:/CurrentDateTime:$CURRENT_DATE_TIME:/")

# Extract the repository path from the CSV file
REPO_PATH=$(awk -F',' 'NR==2 {print $6}' "$CSV_FILE")

# Navigate to the repository path
cd "$REPO_PATH" || { echo "Repository path not found"; exit 1; }

# Stage all changes
git add .

# Commit the changes with the formatted message
git commit -m "$COMMIT_MESSAGE"

# Push the changes to the remote repository
BRANCH_NAME=$(echo $COMMIT_MESSAGE | awk -F':' '{print $6}')
git push origin "$BRANCH_NAME"