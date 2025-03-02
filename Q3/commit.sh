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

# Extract the branch name from the commit message
BRANCH_NAME=$(echo $COMMIT_MESSAGE | awk -F':' '{print $6}')

# Check if the branch exists on the remote, create it if it does not
git fetch origin
if git show-ref --quiet refs/heads/$BRANCH_NAME; then
    echo "Branch $BRANCH_NAME exists locally."
else
    echo "Branch $BRANCH_NAME does not exist locally. Creating it."
    git checkout -b $BRANCH_NAME
    git push -u origin $BRANCH_NAME
fi

# Push the changes to the remote repository
git push origin "$BRANCH_NAME"