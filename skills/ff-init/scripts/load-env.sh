#!/bin/bash
# ──────────────────────────────────────────────────────────────
# load-env.sh — Load .env variables into your shell environment
# ──────────────────────────────────────────────────────────────
# Usage:
#   source load-env.sh /path/to/.env                        # one file
#   source load-env.sh /path/core/.env /path/dept/.env       # multiple files
#   source load-env.sh --persist /path/to/.env               # persist to profile
#
# Accepts one or more .env file paths as arguments. Department
# vars override core vars when the same key appears in both.
# ──────────────────────────────────────────────────────────────

# Detect shell profile
if [ -n "${ZSH_VERSION:-}" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -n "${BASH_VERSION:-}" ]; then
    PROFILE="$HOME/.bashrc"
else
    PROFILE="$HOME/.profile"
fi

PERSIST=false
ENV_FILES=()

# Parse arguments
for arg in "$@"; do
    if [ "$arg" = "--persist" ]; then
        PERSIST=true
    else
        ENV_FILES+=("$arg")
    fi
done

if [ ${#ENV_FILES[@]} -eq 0 ]; then
    echo "❌ No .env file paths provided."
    echo "   Usage: source load-env.sh /path/to/.env [/path/to/another/.env]"
    return 1 2>/dev/null || exit 1
fi

TOTAL_LOADED=0
TOTAL_SKIPPED=0
TOTAL_FILES=0

for ENV_FILE in "${ENV_FILES[@]}"; do
    if [ ! -f "$ENV_FILE" ]; then
        echo "⚠️  Skipped: $ENV_FILE (file not found)"
        continue
    fi

    TOTAL_FILES=$((TOTAL_FILES + 1))
    echo "── Loading: $ENV_FILE"

    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        case "$line" in
            ''|\#*) continue ;;
        esac
        # Also skip lines that are only whitespace or start with whitespace+#
        trimmed="${line#"${line%%[![:space:]]*}"}"
        case "$trimmed" in
            ''|\#*) continue ;;
        esac

        # Extract key=value
        KEY="${line%%=*}"
        VALUE="${line#*=}"

        # Skip placeholder values
        case "$VALUE" in
            *your-*|*CHANGE_ME*|"")
                echo "  ⚠️  Skipped $KEY (placeholder)"
                TOTAL_SKIPPED=$((TOTAL_SKIPPED + 1))
                continue
                ;;
        esac

        # Export to current session
        export "$KEY=$VALUE"
        TOTAL_LOADED=$((TOTAL_LOADED + 1))

        if $PERSIST; then
            # Remove any existing export for this key, then append
            if grep -q "^export $KEY=" "$PROFILE" 2>/dev/null; then
                sed -i '' "/^export $KEY=/d" "$PROFILE" 2>/dev/null || \
                sed -i "/^export $KEY=/d" "$PROFILE"
            fi
            echo "export $KEY=\"$VALUE\"" >> "$PROFILE"
            echo "  ✅ $KEY → persisted to $PROFILE"
        else
            echo "  ✅ $KEY → exported (session only)"
        fi
    done < "$ENV_FILE"
done

echo ""
echo "── Summary ──────────────────────────────────────"
echo "   Files:   $TOTAL_FILES processed"
echo "   Loaded:  $TOTAL_LOADED variable(s)"
echo "   Skipped: $TOTAL_SKIPPED variable(s) (placeholders)"
if $PERSIST; then
    echo "   Persisted to: $PROFILE"
fi
echo "─────────────────────────────────────────────────"

# Output JSON-compatible counts for the AI to parse
echo "LOAD_ENV_RESULT={\"loaded\":$TOTAL_LOADED,\"skipped\":$TOTAL_SKIPPED,\"persisted\":$PERSIST}"
