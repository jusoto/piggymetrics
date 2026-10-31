#!/usr/bin/env bash
set -euo pipefail

# Graceful shutdown for both processes
term_handler() {
  kill -TERM "${JAVA_PID:-0}" 2>/dev/null || true
  kill -TERM "${ENVOY_PID:-0}" 2>/dev/null || true
  wait ${JAVA_PID:-0} ${ENVOY_PID:-0} 2>/dev/null || true
}

trap term_handler SIGTERM SIGINT

# 1) Start Envoy (must listen on 4000 and proxy to 127.0.0.1:4001)
#    Make sure your envoy.yaml matches this port pairing.
 /usr/local/bin/envoy -c /etc/envoy/envoy.yaml --log-level info &
ENVOY_PID=$!

# 2) Start Spring Boot on 4001 but ADVERTISE 4000 to Eureka
java $JAVA_OPTS \
  -Dserver.port=4001 \
  -Deureka.instance.non-secure-port=4000 \
  -Djava.security.egd=file:/dev/./urandom \
  -jar /app/gateway.jar &
JAVA_PID=$!

# Exit when one of them exits
wait -n "$JAVA_PID" "$ENVOY_PID"
term_handler
