#!/usr/bin/env bash
set -euo pipefail

# --- OS and Shell ---
kernel=$(uname -s 2>/dev/null || echo "UNKNOWN")

case "$kernel" in
  Darwin)       os="darwin"  shell_type="bash" ;;
  Linux)        os="linux"   shell_type="bash" ;;
  MINGW*|MSYS*|CYGWIN*)
                os="windows" shell_type="bash" ;;
  *)            os="unknown" shell_type="bash" ;;
esac

echo "SHELL_TYPE=${shell_type}"
echo "OS=${os}"

# --- Package Managers ---
pkg_managers=()
for cmd in dotnet npm yarn pnpm terraform az docker; do
  if command -v "$cmd" &>/dev/null; then
    pkg_managers+=("$cmd")
  fi
done

IFS=','
echo "PACKAGE_MANAGERS=${pkg_managers[*]:-none}"
unset IFS

# --- Tech Stack (scan workspace roots for markers) ---
tech_stack=()
scan_dirs=()

if [ -n "${WORKSPACE_ROOTS:-}" ]; then
  IFS=':' read -ra scan_dirs <<< "$WORKSPACE_ROOTS"
else
  scan_dirs=(".")
fi

for dir in "${scan_dirs[@]}"; do
  [ -d "$dir" ] || continue

  if compgen -G "$dir"/*.csproj >/dev/null 2>&1 || \
     compgen -G "$dir"/*.sln >/dev/null 2>&1 || \
     compgen -G "$dir"/*.fsproj >/dev/null 2>&1; then
    tech_stack+=("dotnet")
  fi

  if [ -f "$dir/package.json" ]; then
    if grep -q '"typescript"' "$dir/package.json" 2>/dev/null; then
      tech_stack+=("typescript")
    else
      tech_stack+=("javascript")
    fi
  fi

  if compgen -G "$dir"/*.tf >/dev/null 2>&1 || [ -d "$dir/terraform" ]; then
    tech_stack+=("terraform")
  fi

  if [ -f "$dir/go.mod" ]; then
    tech_stack+=("go")
  fi

  if [ -f "$dir/Cargo.toml" ]; then
    tech_stack+=("rust")
  fi

  if [ -f "$dir/docker-compose.yml" ] || [ -f "$dir/docker-compose.yaml" ] || [ -f "$dir/Dockerfile" ]; then
    tech_stack+=("docker")
  fi

  if [ -f "$dir/azure-pipelines.yml" ]; then
    tech_stack+=("azure")
  fi

  if [ -f "$dir/requirements.txt" ] || [ -f "$dir/pyproject.toml" ] || \
     compgen -G "$dir"/*.py >/dev/null 2>&1; then
    tech_stack+=("python")
  fi
done

# Deduplicate
unique_tech=$(printf '%s\n' "${tech_stack[@]}" | sort -u | tr '\n' ',' | sed 's/,$//')
echo "TECH_STACK=${unique_tech:-none}"
