#!/usr/bin/env bash
set -euo pipefail

kernel=$(uname -s 2>/dev/null || echo "UNKNOWN")

case "$kernel" in
  Darwin)       os="darwin"  shell_type="bash" ;;
  Linux)        os="linux"   shell_type="bash" ;;
  MINGW*|MSYS*|CYGWIN*)
                os="windows" shell_type="bash" ;;
  *)            os="unknown" shell_type="bash" ;;
esac

echo "SHELL_TYPE=${shell_type} OS=${os}"
