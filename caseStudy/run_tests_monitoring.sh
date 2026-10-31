#!/bin/bash

# Define the log file
LOG_FILE="system_metrics.log"

# Function to collect system metrics and append them to the log file
collect_metrics() {
    # Get timestamp
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # Get CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

    # Get memory usage
    MEM_USAGE=$(free | awk 'NR==2{printf "%.2f", $3*100/$2}')

    # Get I/O usage
    IO_USAGE=$(iostat -d | grep sda | awk '{print $2,$3}')

    # Write to log file
    echo "$TIMESTAMP CPU Usage: $CPU_USAGE% | Memory Usage: $MEM_USAGE% | I/O Usage (read write): $IO_USAGE" >> "$LOG_FILE"
}

# Function to run test_cases.sh and monitor metrics
run_tests_and_monitor_metrics() {
    # Run test_cases.sh
    ./test_cases.sh 10000 1,2,3,4,5 micros1 micros1_05012024_test_case
    
    # Stop monitoring metrics when test_cases.sh finishes
    kill -SIGINT $MONITOR_PID
}

# Main loop to continuously collect metrics and log them
while true; do
    collect_metrics
    sleep 1  # Adjust this if you want to change the frequency
done &
MONITOR_PID=$!

# Run tests and monitor metrics
run_tests_and_monitor_metrics

