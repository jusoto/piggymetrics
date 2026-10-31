#!/usr/bin/env bash
set -euo pipefail

# Let’s ensure clean shutdown for both processes
term_handler() {
  kill -TERM "${JAVA_PID:-0}" 2>/dev/null || true
  kill -TERM "${ENVOY_PID:-0}" 2>/dev/null || true
  wait ${JAVA_PID:-0} ${ENVOY_PID:-0} 2>/dev/null || true
}

trap term_handler SIGTERM SIGINT

# Start Envoy (listener 6000) in background
/usr/local/bin/envoy -c /etc/envoy/envoy.yaml --log-level info &
ENVOY_PID=$!

# Start Spring Boot on 6001 and advertise 6000 to Eureka
java $JAVA_OPTS \
  -Dserver.port=6001 \
  -Deureka.instance.non-secure-port=6000 \
  -Djava.security.egd=file:/dev/./urandom \
  -jar /app/account-service.jar &
JAVA_PID=$!

wait -n $JAVA_PID $ENVOY_PID
# If one dies, terminate the other
term_handler
