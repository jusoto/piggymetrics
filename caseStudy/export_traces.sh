#!/bin/bash

# Export every trace stored in the monitor (Zipkin 2.11.9 with in-memory storage) to a gzipped JSON file.
# In-memory traces are lost when the monitor stops, so run this after the test cases finish
# and before the stack is torn down.
# The monitor keeps at most ZIPKIN_STORAGE_MEM_MAXSPANS spans and evicts the oldest ones after that.

# If one command fails all the script fails
set -o errexit -o pipefail

output_filename=$1
monitor_url=${2:-http://localhost:9411}

# Expected usage
# Example: export_traces.sh ~/micros1_test_case_traces http://localhost:9411
if [[ -z "$output_filename" ]]; then
  echo "ERROR:
  Output filename is missing.

  Usage: export_traces.sh output_filename [monitor_url]

Aborting.
  "
  exit 1
fi

# Look back 30 days from now so the whole run is included
end_ts=$(($(date +%s%N) / 1000000))
lookback=$((30 * 24 * 3600 * 1000))

curl -sf "$monitor_url/api/v2/traces?endTs=$end_ts&lookback=$lookback&limit=100000000" | gzip > "$output_filename.json.gz"

# Report how many traces and spans were exported
zcat "$output_filename.json.gz" | python3 -c '
import sys, json
traces = json.load(sys.stdin)
print("Exported %d traces, %d spans" % (len(traces), sum(len(t) for t in traces)))'
echo "Traces saved to $output_filename.json.gz"
