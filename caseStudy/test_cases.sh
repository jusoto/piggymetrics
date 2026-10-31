#!/bin/bash

# This script is meant to execute n times a HTTP request

# If one command fails all the script fails
set -o errexit

# Global variables
times=$1
IFS=',' read -r -a test_cases <<< "$2"
hostname=$3
mkdir -p output
output_filename="~/Documents/Projects/FIU/paper/v1/piggymetrics/CaseStudy/output/$4"
echo "test_cases: $test_cases"

# Format to store HTTP response times
format="%{http_code},%{time_namelookup},%{time_connect},%{time_appconnect},%{time_pretransfer},%{time_redirect},%{time_starttransfer},%{time_total}"
file_header="http_code,time_namelookup,time_connect,time_appconnect,time_pretransfer,time_redirect,time_starttransfer,time_total"

#keep track of test cases that have finished
test1_finished=true
test2_finished=true
test3_finished=true
test4_finished=true
test5_finished=true

# Expected usage
# Example: test_cases.sh 100 1,2,3,4,5 localhost output_filename
main () {

  if [[ (-z "$times") || (-z "$test_cases") ]]
  then
    echo "ERROR:
  One or more parameters are missing.

  Usage: test_cases.sh 100 1,2,3,4,5 localhost output_filename

Aborting.
    "
    exit 1
  fi

  before_all

  for element in "${test_cases[@]}"
  do
      case $element in
        1)
          run_test_case_1
          test1_finished=true
          ;;
        2)
          run_test_case_2
          test2_finished=true
          ;;
        3)
          run_test_case_3
          test3_finished=true
          ;;
        4)
          run_test_case_4
          test4_finished=true
          ;;
        5)
          run_test_case_5
          test5_finished=true
          ;;
      esac
  done

  after_all
}

before_all(){
  # Services
  GATEWAY="gateway"
  ACCOUNTSERVICE="accounts"
  NOTIFICATIONSERVICE="notifications"
  STATISTICSSERVICE="statistics"

  # Gateway port
  GATEWAY_PORT=80

  # # Register New User
  # local url="$hostname/$ACCOUNTSERVICE"
  # local response=$(curl -X POST -s $url \
  #   -H 'Content-Type: application/json' \
  #   -H 'Authorization: Basic YnJvd3Nlcjo=' \
  #   -H 'Accept: application/json' \
  #   -d '{"username":"user4","password":"password"}')
  # resp=$($response)

  # Get server token
  local url_server="$hostname/uaa/oauth/token"
  local server_response=$(curl -X POST -s $url_server \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Authorization: Basic c3RhdGlzdGljcy1zZXJ2aWNlOnBhc3N3b3Jk' \
    -d 'grant_type=client_credentials&scope=server')
  server_token=$(echo $server_response | jq -r '.access_token')
  echo "Server Token: $server_token"

  # Get token
  local url="$hostname/uaa/oauth/token"
  local response=$(curl -X POST -s $url \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Authorization: Basic YnJvd3Nlcjo=' \
    -d 'grant_type=password&scope=ui&username=user1&password=password')
  token=$( echo $response | jq -r '.access_token' )
  echo "Token: $token"

  # # Get account information
  # local url="$hostname/$ACCOUNTSERVICE/current"
  # local response=$(curl -X GET \
  #   -s $url \
  #   -H 'Content-Type: application/json' \
  #   -H "Authorization: Bearer $token" \
  #   -H 'Accept: application/json' )
  # tripId_tc4=${response}
}

after_all(){
  
  if($test1_finished && $test2_finished && $test3_finished && $test4_finished && $test5_finished); then
    echo "All test cases were executed."
  else
    echo "Some test cases were not executed."
  fi

  if [ "$test1_finished" != true ]; then
    echo "Test case 1 was not executed."
  fi
  if [ "$test2_finished" != true ]; then
    echo "Test case 2 was not executed."
  fi
  if [ "$test3_finished" != true ]; then
    echo "Test case 3 was not executed."
  fi
  if [ "$test4_finished" != true ]; then
    echo "Test case 4 was not executed."
  fi
  if [ "$test5_finished" != true ]; then
    echo "Test case 5 was not executed."
  fi

}

run_test_case_1(){
  test1_finished=false
  echo "Test case 1 started."
  local output_filename_1=$output_filename"_1.csv"
  rm -f $output_filename_1
  mkdir -p "$(dirname "$output_filename_1")"
  echo "1. Add Incomes, Expenses and Savings to existing account"
  echo $file_header | tee -a $output_filename_1
  local url="$hostname/$ACCOUNTSERVICE/current"
  for ((i=1;i<=$times;i++)); 
  do
    local response=$(curl -X PUT \
      -w $format \
      --silent $url \
		  --output /dev/null \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer $token" \
      -d '{
            "incomes": [
              {
                "title": "Salary",
                "amount": 3000,
                "currency": "USD",
                "period": "MONTH",
                "icon": "wallet"
              }
            ],
            "expenses": [
              {
                "title": "Rent",
                "amount": 1200,
                "currency": "USD",
                "period": "MONTH",
                "icon": "wallet"
              },
              {
                "title": "Groceries",
                "amount": 300,
                "currency": "USD",
                "period": "MONTH",
                "icon": "wallet"
              }
            ],
            "saving": {
              "amount": 500,
              "currency": "USD",
              "interest": 3.2,
              "deposit": true,
              "capitalization": false
            }
          }')
    echo $response | tee -a $output_filename_1
    local status=${response:0:3}
    if [[ "$status" -ge "200" && "$status" -lt "300" ]];
    then
      echo "PASS"
    else
      echo "FAILS"
      echo "Response: $response"
    fi
  done
  echo "Test case 1 finished."
}

run_test_case_2(){
  test2_finished=false
  echo "Test case 2 started."
  local output_filename_2=$output_filename"_2.csv"
  rm -f $output_filename_2
  echo "2. Get current account statistics"
  echo $file_header |& tee -a $output_filename_2
  local url="$hostname/$STATISTICSSERVICE/current"
  for ((i=1;i<=$times;i++)); 
  do
    local response=$(curl -X GET \
      -w $format \
      -s $url \
		  --output /dev/null \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer $token" \
      -H 'Accept: application/json' \
      -d '' )
    echo $response |& tee -a $output_filename_2
    local status=${response:0:3}
    if [[ "$status" -ge "200" && "$status" -lt "300" ]];
    then
      echo "PASS"
    else
      echo "FAILS"
    fi
  done
  echo "Test case 2 finished."
}

run_test_case_3(){
  test3_finished=false
  echo "Test case 3 started."
  local output_filename_3=$output_filename"_3.csv"
  rm -f $output_filename_3
  echo "3. Create or update time series datapoint for specified account"
  echo $file_header |& tee -a $output_filename_3
  local url="$hostname/$STATISTICSSERVICE/user1"
  for ((i=1;i<=$times;i++)); 
  do
    local response=$(curl -X PUT \
      -w $format \
      -s $url \
		  --output /dev/null \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer $server_token" \
      -H 'Accept: application/json' \
      -d '{
            "incomes": [
              {
                "title": "Salary",
                "amount": 3000,
                "currency": "USD",
                "period": "MONTH",
                "icon": "wallet"
              }
            ],
            "expenses": [
              {
                "title": "Rent",
                "amount": 1200,
                "currency": "USD",
                "period": "MONTH",
                "icon": "wallet"
              },
              {
                "title": "Groceries",
                "amount": 300,
                "currency": "USD",
                "period": "MONTH",
                "icon": "wallet"
              }
            ],
            "saving": {
              "amount": 500,
              "currency": "USD",
              "interest": 3.32,
              "deposit": true,
              "capitalization": false
            }
          }')
    echo $response |& tee -a $output_filename_3
    local status=${response:0:3}
    if [[ "$status" -ge "200" && "$status" -lt "300" ]];
    then
      echo "PASS"
    else
      echo "FAILS"
    fi
  done
  echo "Test case 3 finished."
}

run_test_case_4(){
  test2_finished=false
  echo "Test case 2 started."
  local output_filename_4=$output_filename"_4.csv"
  rm -f $output_filename_4
  echo "4. Get current account notification settings"
  echo $file_header |& tee -a $output_filename_4
  local url="$hostname/$NOTIFICATIONSERVICE/recipients/current"
  for ((i=1;i<=$times;i++)); 
  do
    local response=$(curl -X GET \
      -w $format \
      -s $url \
		  --output /dev/null \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer $token" \
      -H 'Accept: application/json' \
      -d '' )
    echo $response |& tee -a $output_filename_4
    local status=${response:0:3}
    if [[ "$status" -ge "200" && "$status" -lt "300" ]];
    then
      echo "PASS"
    else
      echo "FAILS"
    fi
  done
  echo "Test case 4 finished."
}

run_test_case_5(){
  test5_finished=false
  echo "Test case 5 started."
  local output_filename_5=$output_filename"_5.csv"
  rm -f $output_filename_5
  echo "5. Save current account notification settings"
  echo $file_header |& tee -a $output_filename_5
  local url="$hostname/$NOTIFICATIONSERVICE/recipients/current"
  for ((i=1;i<=$times;i++)); 
  do
    local response=$(curl -X PUT \
      -w $format \
      -s $url \
		  --output /dev/null \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer $token" \
      -H 'Accept: application/json' \
      -d '{
            "email": "user1@example.com",
            "scheduledNotifications": {
              "REMIND": {
                "active": true,
                "frequency": "WEEKLY"
              },
              "BACKUP": {
                "active": true,
                "frequency": "MONTHLY"
              }
            }
          }' )
    echo $response |& tee -a $output_filename_5
    local status=${response:0:3}
    if [[ "$status" -ge "200" && "$status" -lt "300" ]];
    then
      echo "PASS"
    else
      echo "FAILS"
    fi
  done
  echo "Test case 5 finished."
}

main "$@"
