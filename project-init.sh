#!/bin/bash

# 현재 스크립트의 디렉토리 경로를 찾습니다.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="${SCRIPT_DIR}"

if [ $# -lt 1 ]; then
  echo "Usage: project-init <type>"
  exit 1
fi

PROJECT_TYPE=$1


SCRIPT_PATH="${WORKDIR}/${PROJECT_TYPE}/main.sh"

echo $SCRIPT_PATH

if [ ! -f "$SCRIPT_PATH" ]; then
  echo "Error: Script for '$PROJECT_TYPE' not found."
  exit 1
fi

bash "$SCRIPT_PATH"

