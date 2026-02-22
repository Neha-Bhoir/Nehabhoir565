#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-4173}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="${ROOT_DIR}/.preview.pid"
LOG_FILE="${ROOT_DIR}/.preview.log"

if [[ "${PORT}" == "--stop" ]]; then
  if [[ -f "${PID_FILE}" ]]; then
    PID="$(cat "${PID_FILE}")"
    if kill -0 "${PID}" 2>/dev/null; then
      kill "${PID}"
      echo "Stopped preview server (PID ${PID})."
    else
      echo "Preview PID file found, but process is not running."
    fi
    rm -f "${PID_FILE}"
  else
    echo "No preview server PID file found."
  fi
  exit 0
fi

if [[ -f "${PID_FILE}" ]]; then
  OLD_PID="$(cat "${PID_FILE}")"
  if kill -0 "${OLD_PID}" 2>/dev/null; then
    echo "Preview already running on PID ${OLD_PID}."
    echo "Open: http://127.0.0.1:${PORT}/"
    exit 0
  else
    rm -f "${PID_FILE}"
  fi
fi

cd "${ROOT_DIR}/funnel"
nohup python3 -m http.server "${PORT}" --bind 0.0.0.0 >"${LOG_FILE}" 2>&1 &
PID=$!
echo "${PID}" > "${PID_FILE}"

for _ in {1..20}; do
  if curl -s "http://127.0.0.1:${PORT}/" >/dev/null 2>&1; then
    echo "Preview started successfully."
    echo "URL: http://127.0.0.1:${PORT}/"
    echo "PID: ${PID}"
    echo "Log: ${LOG_FILE}"
    echo "Stop with: ./preview.sh --stop"
    exit 0
  fi
  sleep 0.25
done

echo "Failed to start preview server. Check log: ${LOG_FILE}"
exit 1
