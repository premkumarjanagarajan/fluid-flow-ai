#!/usr/bin/env bash
set -eo pipefail

# ──────────────────────────────────────────────────────────────
# environment-detection.bash
# ──────────────────────────────────────────────────────────────
# Usage:
#   bash environment-detection.bash [dir1 dir2 ...]
#
# Pass workspace root directories as arguments. If none given,
# falls back to $WORKSPACE_ROOTS (colon-separated) or ".".
#
# Output: single JSON object to stdout.
# ──────────────────────────────────────────────────────────────

# --- OS and Shell ---
kernel=$(uname -s 2>/dev/null || echo "UNKNOWN")

case "$kernel" in
  Darwin)       os="darwin"  shell_type="bash" ;;
  Linux)        os="linux"   shell_type="bash" ;;
  MINGW*|MSYS*|CYGWIN*)
                os="windows" shell_type="bash" ;;
  *)            os="unknown" shell_type="bash" ;;
esac

# --- Package Managers ---
pkg_managers=()
for cmd in dotnet npm yarn pnpm terraform az docker pip; do
  if command -v "$cmd" &>/dev/null; then
    pkg_managers+=("$cmd")
  fi
done

if [ ${#pkg_managers[@]} -eq 0 ]; then
  pkg_csv="none"
else
  IFS=','
  pkg_csv="${pkg_managers[*]}"
  unset IFS
fi

# --- Resolve scan directories from args, env, or fallback ---
scan_dirs=()
if [ $# -gt 0 ]; then
  scan_dirs=("$@")
elif [ -n "${WORKSPACE_ROOTS:-}" ]; then
  IFS=':' read -ra scan_dirs <<< "$WORKSPACE_ROOTS"
else
  scan_dirs=(".")
fi

# --- Tech Stack + Source Repo Classification (single pass) ---
tech_stack=()
repo_json_items=()

for dir in "${scan_dirs[@]}"; do
  [ -d "$dir" ] || continue
  repo_name=$(basename "$dir")
  repo_type="greenfield"
  has_code=false

  # .csproj / .sln / .fsproj → dotnet
  if find "$dir" -maxdepth 3 \( -name "*.csproj" -o -name "*.sln" -o -name "*.fsproj" \) -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("dotnet"); has_code=true
  fi

  # package.json → typescript or javascript
  pkg_json=$(find "$dir" -maxdepth 2 -name "package.json" -print -quit 2>/dev/null)
  if [ -n "$pkg_json" ]; then
    if grep -q '"typescript"' "$pkg_json" 2>/dev/null; then
      tech_stack+=("typescript")
    else
      tech_stack+=("javascript")
    fi
    has_code=true
  fi

  # *.tf / terraform/ → terraform
  if find "$dir" -maxdepth 2 \( -name "*.tf" -o -name "terraform" -type d \) -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("terraform"); has_code=true
  fi

  # go.mod → go
  if find "$dir" -maxdepth 2 -name "go.mod" -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("go"); has_code=true
  fi

  # Cargo.toml → rust
  if find "$dir" -maxdepth 2 -name "Cargo.toml" -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("rust"); has_code=true
  fi

  # docker-compose.yml / Dockerfile → docker
  if find "$dir" -maxdepth 2 \( -name "docker-compose.yml" -o -name "docker-compose.yaml" -o -name "Dockerfile" \) -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("docker"); has_code=true
  fi

  # azure-pipelines.yml → azure
  if find "$dir" -maxdepth 2 -name "azure-pipelines.yml" -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("azure"); has_code=true
  fi

  # *.py / requirements.txt / pyproject.toml → python
  if find "$dir" -maxdepth 3 \( -name "*.py" -o -name "requirements.txt" -o -name "pyproject.toml" \) -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("python"); has_code=true
  fi

  # *.sql → sql
  if find "$dir" -maxdepth 3 -name "*.sql" -print -quit 2>/dev/null | grep -q .; then
    tech_stack+=("sql"); has_code=true
  fi

  if $has_code; then
    repo_type="brownfield"
  fi

  # Check reverse-engineering timestamp
  re_ts="null"
  re_file="$dir/reverse-engineering/reverse-engineering-timestamp.md"
  if [ -f "$re_file" ]; then
    extracted=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9:ZT+-]+' "$re_file" 2>/dev/null | head -1)
    if [ -n "$extracted" ]; then
      re_ts="\"$extracted\""
    fi
  fi

  repo_json_items+=("{\"name\":\"$repo_name\",\"type\":\"$repo_type\",\"reTimestamp\":$re_ts}")
done

# Deduplicate tech stack
if [ ${#tech_stack[@]} -eq 0 ]; then
  tech_csv="none"
else
  tech_csv=$(printf '%s\n' "${tech_stack[@]}" | sort -u | tr '\n' ',' | sed 's/,$//')
fi

# Build repos JSON array
repos_json="["
first=true
for item in "${repo_json_items[@]}"; do
  if $first; then first=false; else repos_json+=","; fi
  repos_json+="$item"
done
repos_json+="]"

# --- Output JSON ---
cat <<EOF
{
  "os": "$os",
  "shellType": "$shell_type",
  "packageManagers": "$pkg_csv",
  "techStack": "$tech_csv",
  "sourceRepos": $repos_json
}
EOF
