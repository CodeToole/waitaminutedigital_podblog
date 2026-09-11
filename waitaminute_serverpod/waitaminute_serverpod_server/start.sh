#!/bin/sh
set -e

echo "==> Starting Serverpod Monolith (with automatic migrations)..."
./server --mode=production --server-id=default --logging=normal --role=monolith --apply-migrations &
SERVER_PID=$!

# Background watchdog: if the Serverpod server process exits, kill the container
(
  while kill -0 $SERVER_PID 2>/dev/null; do
    sleep 2
  done
  echo "==> ERROR: Serverpod process (PID $SERVER_PID) exited unexpectedly! Terminating container."
  kill -s TERM $$ 2>/dev/null || exit 1
) &
WATCHDOG_PID=$!

echo "==> Waiting for Serverpod web server to become healthy on http://127.0.0.1:8082/..."
TIMEOUT=90
COUNTER=0

until wget -q --spider http://127.0.0.1:8082/ 2>/dev/null; do
  sleep 1
  COUNTER=$((COUNTER + 1))
  if [ $COUNTER -ge $TIMEOUT ]; then
    echo "==> ERROR: Timed out ($TIMEOUT s) waiting for Serverpod startup."
    kill $SERVER_PID 2>/dev/null || true
    kill $WATCHDOG_PID 2>/dev/null || true
    exit 1
  fi
  # If the server process died while waiting, exit immediately
  if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo "==> ERROR: Serverpod process crashed during startup."
    kill $WATCHDOG_PID 2>/dev/null || true
    exit 1
  fi
done

echo "==> Serverpod is healthy! Launching Caddy reverse proxy on port 8080..."
exec caddy run --config /app/Caddyfile --adapter caddyfile
