#!/bin/bash

CSV_FILE="DevBug.csv"
HISTORY_FILE="commit_history.txt"

# Ensure the CSV file exists in the same directory as the script
if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: CSV file '$CSV_FILE' not found!" >&2
    exit 1
fi

# Read the required data from the CSV file using awk
data=$(awk -F',' 'NR==2 {print "BugID:" $1 ":CurrentDateTime::BranchName:" $3 ":DevName:" $4 ":Priority:" $5 ":ExcelDescription:" $2}' "$CSV_FILE")

# Get current date and time
CURRENT_DATE_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Append current date and time to the data
COMMIT_MESSAGE=$(echo $data | sed "s/CurrentDateTime:/CurrentDateTime:$CURRENT_DATE_TIME:/")

# Stage all changes
git add .

# Commit the changes with the formatted message
git commit -m "$COMMIT_MESSAGE"
if [[ $? -ne 0 ]]; then
    echo "Error: Commit failed!" >&2
    exit 1
fi

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
if [[ $? -ne 0 ]]; then
    echo "Error: Push failed!" >&2
    exit 1
fi

# Ensure the history file exists
touch "$HISTORY_FILE"

# Print the commit history to the file
git log > "$HISTORY_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to write commit history to '$HISTORY_FILE'" >&2
    exit 1
fi

echo "Script executed successfully. Commit history saved to '$HISTORY_FILE'."