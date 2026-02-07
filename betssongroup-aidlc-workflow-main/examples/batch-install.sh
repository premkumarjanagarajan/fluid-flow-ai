#!/bin/bash
# Example script for batch installation with progress tracking

set -e

REPO_LIST="$1"
LOG_FILE="installation-$(date +%Y%m%d-%H%M%S).log"

if [ -z "$REPO_LIST" ]; then
    echo "Usage: $0 <repo-list-file>"
    echo "Example: $0 repos.txt"
    exit 1
fi

if [ ! -f "$REPO_LIST" ]; then
    echo "Error: File not found: $REPO_LIST"
    exit 1
fi

echo "Starting batch installation..."
echo "Repository list: $REPO_LIST"
echo "Log file: $LOG_FILE"
echo ""

# Count total repositories (excluding comments and empty lines)
TOTAL=$(grep -v '^#' "$REPO_LIST" | grep -v '^[[:space:]]*$' | wc -l | tr -d ' ')
CURRENT=0
SUCCESS=0
FAILED=0

echo "Total repositories to process: $TOTAL"
echo ""

while IFS= read -r repo; do
    # Skip comments and empty lines
    if [[ "$repo" =~ ^#.*$ ]] || [[ -z "$repo" ]]; then
        continue
    fi
    
    CURRENT=$((CURRENT + 1))
    echo "[$CURRENT/$TOTAL] Processing: $repo" | tee -a "$LOG_FILE"
    
    if aidlc install --path "$repo" >> "$LOG_FILE" 2>&1; then
        SUCCESS=$((SUCCESS + 1))
        echo "  ✓ Success" | tee -a "$LOG_FILE"
    else
        FAILED=$((FAILED + 1))
        echo "  ✗ Failed" | tee -a "$LOG_FILE"
    fi
    
    echo "" | tee -a "$LOG_FILE"
done < "$REPO_LIST"

echo "========================================" | tee -a "$LOG_FILE"
echo "Batch installation complete!" | tee -a "$LOG_FILE"
echo "Total: $TOTAL" | tee -a "$LOG_FILE"
echo "Success: $SUCCESS" | tee -a "$LOG_FILE"
echo "Failed: $FAILED" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
