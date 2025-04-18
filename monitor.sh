#!/bin/bash

# --- Prompt User for Threshold Values ---
read -p "Enter CPU usage threshold (in %): " THRESHOLD_CPU
read -p "Enter Disk usage threshold (in %): " THRESHOLD_DISK
read -p "Enter Memory usage threshold (in %): " THRESHOLD_MEMORY

# --- Configuration ---
RECIPIENT_EMAIL="442006karthik@gmail.com"
EMAIL_SUBJECT="Alert: Resource Usage Exceeded Threshold"

# --- Helper function to send email ---
send_email() {
  local component="$1"
  local usage="$2"
  local threshold="$3"
  local body="Subject: $EMAIL_SUBJECT\n\nWarning: The usage of $component ($usage%) has exceeded the threshold of $threshold%."
  local from_address="Server Monitor <442006kkarthik@gmail.com>" # Set your desired From: address here

  # Send email using msmtp
  echo -e "$body" | msmtp -a "default" "$RECIPIENT_EMAIL"
}

# --- Check CPU Usage ---
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*id,[[:space:]]*\([0-9.]*\)%.*/\1/" | awk '{print 100 - $1}')
echo "CPU Usage: $cpu_usage%"  # Debugging output

if (( $(echo "$cpu_usage > $THRESHOLD_CPU" | bc -l) )); then
  echo "CPU usage ($cpu_usage%) is above threshold. Sending email..."  # Debugging output
  send_email "CPU" "$cpu_usage" "$THRESHOLD_CPU"
else
  echo "CPU usage ($cpu_usage%) is below threshold"  # Debugging output
fi

# --- Check Disk Usage ---
disk_usage=$(df / | awk 'NR==2{print $5}' | sed 's/%//')
echo "Disk Usage: $disk_usage%"  # Debugging output

if (( $(echo "$disk_usage > $THRESHOLD_DISK" | bc -l) )); then
  echo "Disk usage ($disk_usage%) is above threshold. Sending email..."  # Debugging output
  send_email "Disk" "$disk_usage" "$THRESHOLD_DISK"
else
  echo "Disk usage ($disk_usage%) is below threshold"  # Debugging output
fi

# --- Check Memory Usage ---
free=$(free -m | awk 'NR==2{print $3}')
total=$(free -m | awk 'NR==2{print $2}')
memory_usage=$(( (free * 100) / total ))
memory_usage=$((100 - memory_usage)) # Calculate used percentage
echo "Memory Usage: $memory_usage%"  # Debugging output

if (( $(echo "$memory_usage > $THRESHOLD_MEMORY" | bc -l) )); then
  echo "Memory usage ($memory_usage%) is above threshold. Sending email..."  # Debugging output
  send_email "Memory" "$memory_usage" "$THRESHOLD_MEMORY"
else
  echo "Memory usage ($memory_usage%) is below threshold"  # Debugging output
fi

echo "Monitoring completed."
