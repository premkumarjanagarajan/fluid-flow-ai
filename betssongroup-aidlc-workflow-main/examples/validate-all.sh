#!/bin/bash
# Example script to validate workflow installations across multiple repositories

set -e

REPO_LIST="$1"
REPORT_FILE="validation-report-$(date +%Y%m%d-%H%M%S).txt"

if [ -z "$REPO_LIST" ]; then
    echo "Usage: $0 <repo-list-file>"
    echo "Example: $0 repos.txt"
    exit 1
fi

if [ ! -f "$REPO_LIST" ]; then
    echo "Error: File not found: $REPO_LIST"
    exit 1
fi

echo "AI-DLC Workflow Validation Report" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

TOTAL=0
VALID=0
INVALID=0

while IFS= read -r repo; do
    # Skip comments and empty lines
    if [[ "$repo" =~ ^#.*$ ]] || [[ -z "$repo" ]]; then
        continue
    fi
    
    TOTAL=$((TOTAL + 1))
    echo "Validating: $repo"
    echo "Repository: $repo" >> "$REPORT_FILE"
    
    if aidlc validate --path "$repo" >> "$REPORT_FILE" 2>&1; then
        VALID=$((VALID + 1))
        echo "  ✓ Valid" | tee -a "$REPORT_FILE"
    else
        INVALID=$((INVALID + 1))
        echo "  ✗ Invalid" | tee -a "$REPORT_FILE"
    fi
    
    echo "" >> "$REPORT_FILE"
done < "$REPO_LIST"

echo "========================================" >> "$REPORT_FILE"
echo "Summary:" >> "$REPORT_FILE"
echo "Total Repositories: $TOTAL" >> "$REPORT_FILE"
echo "Valid: $VALID" >> "$REPORT_FILE"
echo "Invalid: $INVALID" >> "$REPORT_FILE"

echo ""
echo "Validation complete!"
echo "Total: $TOTAL"
echo "Valid: $VALID"
echo "Invalid: $INVALID"
echo "Report saved to: $REPORT_FILE"
