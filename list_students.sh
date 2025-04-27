#!/bin/bash

# Define CGPA passing threshold
PASS_THRESHOLD=2.00

# Check if CGPA file exists
if [[ ! -f "cgpa.txt" ]]; then
    echo "❌ No CGPA records found! Run the grading script first."
    exit 1
fi

# Function to list passed students
list_passed_students() {
    echo "🎓 Passed Students (CGPA >= $PASS_THRESHOLD)"
    echo "--------------------------------------"
    awk -F':' -v threshold="$PASS_THRESHOLD" '$2 >= threshold {print $1, "CGPA:", $2}' cgpa.txt | sort -k3 -n
    echo
}

# Function to list failed students
list_failed_students() {
    echo "🚨 Failed Students (CGPA < $PASS_THRESHOLD)"
    echo "--------------------------------------"
    awk -F':' -v threshold="$PASS_THRESHOLD" '$2 < threshold {print $1, "CGPA:", $2}' cgpa.txt | sort -k3 -n
    echo
}

# Main function
list_students() {
    clear
    echo "📋 Student Performance Report"
    echo "============================="

    list_passed_students
    list_failed_students
}

# Run the script
list_students
