#!/bin/bash

# Function to view the student's grades and CGPA
view_results() {
    # Prompt the user to enter their Roll Number
    read -p "Enter your Roll Number: " roll_no

    # Check if the roll number exists in the students.txt file
    if ! grep -q "^$roll_no:" students.txt; then
        # If not found, show an error message and exit the script
        echo "❌ No student found with Roll No: $roll_no"
        exit 1
    fi

    # Display the header for the grades section
    echo "📊 Your Grades:"
    echo "----------------------------"
    printf "%-15s %-10s\n" "Subject" "Grade"  # Print column headers
    echo "----------------------------"

    # Initialize a flag to check if any grades are found
    found_grades=false

    # Loop through all subject files in the 'subjects' directory
    for file in subjects/*.txt; do
        # Get the subject name by extracting the file name without the extension
        subject_name=$(basename "$file" .txt)  
        
        # Check if the roll number exists in the subject file
        if grep -q "^$roll_no:" "$file"; then
            # Extract the grade for the student from the subject file
            grade=$(grep "^$roll_no:" "$file" | cut -d':' -f3)  
            # Print the subject name and corresponding grade
            printf "%-15s %-10s\n" "$subject_name" "$grade"
            found_grades=true  # Set the flag to true as grades are found
        fi
    done

    # If no grades were found for the student, print a message indicating so
    if [ "$found_grades" = false ]; then
        echo "❌ No grades available yet."
    fi

    echo "----------------------------"

    # Get the student's CGPA from the cgpa.txt file
    cgpa=$(grep "^$roll_no:" cgpa.txt | cut -d':' -f2)
    
    # If no CGPA is found, set it to "N/A"
    if [[ -z "$cgpa" ]]; then
        cgpa="N/A"
    fi
    
    # Display the student's CGPA
    echo "🎓 Your CGPA: $cgpa"
}


#run the function
view_results

