#!/bin/bash

# colors def
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# file paths
BASE_DIR="."
ACTIVE_LOGS="$BASE_DIR/active_logs"
ARCHIVE_PATHS=(
  "$BASE_DIR/heart_data_archive"
  "$BASE_DIR/temp_data_archive"
  "$BASE_DIR/water_data_archive"
)
LOG_NAMES=("heart_rate_log.log" "temperature_log.log" "water_usage_log.log")

# menu
echo -e "${BLUE}Select log to archive:${NC}"
echo -e "${YELLOW}1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage${NC}"
read -p "Enter choice (1-3): " choice

# input validation
if [[ ! "$choice" =~ ^[1-3]$ ]]; then
  echo -e "${RED}Invalid option. Please enter 1, 2, or 3.${NC}"
  exit 1
fi

index=$((choice - 1))
selected_log="${LOG_NAMES[$index]}"
log_path="$ACTIVE_LOGS/$selected_log"
archive_dir="${ARCHIVE_PATHS[$index]}"
timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
archived_log="$archive_dir/${selected_log%.log}_$timestamp.log"

# check if log file exists
if [[ ! -f "$log_path" ]]; then
  echo -e "${RED}Log file not found: $log_path${NC}"
  exit 1
fi

# ensure archive directory exists
mkdir -p "$archive_dir" || {
  echo -e "${RED}Failed to create archive directory: $archive_dir${NC}"
  exit 1
}

# archive the log
mv "$log_path" "$archived_log"
touch "$log_path"

echo -e "${GREEN}Archived successfully to:${NC} $archived_log"