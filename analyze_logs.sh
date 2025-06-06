#!/bin/bash

# Function to display menu and get user choice
show_menu() {
    echo "Select log file to analyze:"
    echo "1) Heart Rate (heart_rate.log)"
    echo "2) Temperature (temperature.log)"
    echo "3) Water Usage (water_usage.log)"
    echo -n "Enter choice (1-3): "
}

# Function to validate user input
validate_input() {
    local choice=$1
    if [[ "$choice" =~ ^[1-3]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to get log file path based on choice
get_log_file() {
    local choice=$1
    case $choice in
        1) echo "active_logs/heart_rate_log.log" ;;
        2) echo "active_logs/temperature_log.log" ;;
        3) echo "active_logs/water_usage_log.log" ;;
    esac
}

# Function to get log type name based on choice
get_log_type() {
    local choice=$1
    case $choice in
        1) echo "Heart Rate" ;;
        2) echo "Temperature" ;;
        3) echo "Water Usage" ;;
    esac
}

# Function to analyze log file
analyze_log() {
    local log_file=$1
    local log_type=$2
    
    # Check if log file exists
    if [[ ! -f "$log_file" ]]; then
        echo "Error: Log file '$log_file' not found!"
        return 1
    fi
    
    echo "Analyzing $log_type data from $log_file..."
    
    # Create reports directory if it doesn't exist
    mkdir -p reports
    
    # Prepare report header
    local report_file="./reports/analysis_report.txt"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Append analysis header to report
    echo "" >> "$report_file"
    echo "========================================" >> "$report_file"
    echo "LOG ANALYSIS REPORT" >> "$report_file"
    echo "Generated: $timestamp" >> "$report_file"
    echo "Log Type: $log_type" >> "$report_file"
    echo "Source File: $log_file" >> "$report_file"
    echo "========================================" >> "$report_file"
    
    # Extract device names and count occurrences
    awk '
    {
        device = $3  # Device name is the 3rd field
        count[device]++
        
        # Track first and last timestamps for each device
        if (!(device in first_time)) {
            first_time[device] = $1 " " $2  # Date and time
        }
        last_time[device] = $1 " " $2
    }
    END {
        print "\nDEVICE OCCURRENCE ANALYSIS:"
        print "----------------------------"
        for (device in count) {
            printf "Device: %s\n", device
            printf "  Total Occurrences: %d\n", count[device]
            printf "  First Entry: %s\n", first_time[device]
            printf "  Last Entry: %s\n", last_time[device]
            printf "\n"
        }
        
        print "SUMMARY:"
        print "--------"
        total = 0
        for (device in count) {
            total += count[device]
        }
        printf "Total Devices: %d\n", length(count)
        printf "Total Log Entries: %d\n", total
    }' "$log_file" | tee -a "$report_file"
    
    echo "Analysis complete! Results appended to $report_file"
}

# Main script execution
main() {
    echo
    
    # Show menu and get user choice
    while true; do
        show_menu
        read -r choice
        
        if validate_input "$choice"; then
            break
        else
            echo "Invalid choice. Please enter 1, 2, or 3."
            echo
        fi
    done
    
    # Get corresponding log file and type
    log_file=$(get_log_file "$choice")
    log_type=$(get_log_type "$choice")
    
    # Perform analysis
    analyze_log "$log_file" "$log_type"
}

# Run main function
main "$@"