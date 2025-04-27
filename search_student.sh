#!/bin/bash

STUDENT_FILE="students.txt"
CGPA_FILE="cgpa.txt"

# Function to search for a student
search_student() {
    read -p "🔍 Enter Roll Number to Search: " roll_no

    # Check if the student exists
    if ! grep -q "^$roll_no:" "$STUDENT_FILE"; then
        echo "❌ Student with Roll No: $roll_no not found!"
        exit 1
    fi

    echo "📌 Student Details for Roll No: $roll_no"
    echo "------------------------------------------"
    
    # Fetch Grades
    subjects=("math" "physics" "programming")
    for subject in "${subjects[@]}"; do
        file="subjects/${subject}.txt"
        if grep -q "^$roll_no:" "$file"; then
            grade=$(grep "^$roll_no:" "$file" | cut -d':' -f3)
            echo "$subject: $grade"
        else
            echo "$subject: N/A"
        fi
    done

    # Fetch CGPA
    cgpa=$(grep "^$roll_no:" "$CGPA_FILE" | cut -d':' -f2)
    [[ -z "$cgpa" ]] && cgpa="N/A"
    echo "CGPA: $cgpa"
    echo "------------------------------------------"
}

# Run function
search_student
