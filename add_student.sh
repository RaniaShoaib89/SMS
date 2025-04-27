#!/bin/bash

# File where student credentials are stored
STUDENT_FILE="students.txt"

# Function to add a student
add_student() {
    while true; do
        read -p "Enter Student Roll Number (e.g., 23F-0605): " roll_no

        # Validate the roll number format
        if [[ ! "$roll_no" =~ ^[0-9]{2}[FILPK]-[0-9]{4}$ ]]; then
            echo "❌ Invalid roll number format! Use format: YY[CITY]-XXXX (e.g., 23F-0605)"
            continue
        fi

        # Check if student already exists
        if grep -q "^$roll_no:" "$STUDENT_FILE"; then
            echo "❌ Student with Roll No: $roll_no already exists!"
            exit 1
        fi

        break
    done

    read -s -p "Enter Password: " password
    echo
    read -s -p "Confirm Password: " confirm_password
    echo

    # Check if passwords match
    if [[ "$password" != "$confirm_password" ]]; then
        echo "❌ Passwords do not match. Try again."
        exit 1
    fi

    # Save student details
    echo "$roll_no:$password" >> "$STUDENT_FILE"
    echo "✅ Student added successfully: Roll No - $roll_no"
}

# Ensure the student file exists
touch "$STUDENT_FILE"

# Run function
add_student

