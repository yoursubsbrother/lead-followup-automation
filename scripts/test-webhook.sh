#!/usr/bin/env bash
# Usage: ./scripts/test-webhook.sh <payload-file> [test|prod]
#   test -> /webhook-test/new-lead  (needs "Listen for test event")
#   prod -> /webhook/new-lead       (needs the workflow Published/Active)
set -euo pipefail
PAYLOAD="${1:?pass a payload file from scripts/test-payloads}"
MODE="${2:-test}"
BASE="${N8N_BASE_URL:-http://localhost:5678}"
if [ "$MODE" = "prod" ]; then URL="$BASE/webhook/new-lead"; else URL="$BASE/webhook-test/new-lead"; fi
echo "-> POST $URL"
curl -sS -X POST "$URL" -H 'Content-Type: application/json' --data @"$PAYLOAD"
echo
