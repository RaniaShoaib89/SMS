#!/bin/bash

# Function to calculate grade from marks
calculate_grade() {
    marks=$1
    # Determine the grade based on the marks
    if (( marks >= 90 )); then echo "A"
    elif (( marks >= 85 )); then echo "A-"
    elif (( marks >= 80 )); then echo "B+"
    elif (( marks >= 75 )); then echo "B"
    elif (( marks >= 70 )); then echo "B-"
    elif (( marks >= 65 )); then echo "C+"
    elif (( marks >= 60 )); then echo "C"
    elif (( marks >= 55 )); then echo "C-"
    elif (( marks >= 50 )); then echo "D"
    elif (( marks >= 45 )); then echo "D-"
    else echo "F"
    fi
}

# Function to convert grade to GPA
grade_to_gpa() {
    local grade="${1^^}"  # Convert to uppercase
    # Convert grade to corresponding GPA
    case "$grade" in
        A) echo "4.0" ;;
        A-) echo "3.7" ;;
        B+) echo "3.3" ;;
        B) echo "3.0" ;;
        B-) echo "2.7" ;;
        C+) echo "2.3" ;;
        C) echo "2.0" ;;
        C-) echo "1.7" ;;
        D+) echo "1.3" ;;
        D) echo "1.0" ;;
        D-) echo "0.7" ;;
        F) echo "0.0" ;;
        *) echo "0.0" ;;  # Default case
    esac
}

# Function to calculate CGPA for a student
calculate_cgpa() {
    roll_no=$1
    total_gpa=0
    subject_count=0

    # Loop through each subject file and calculate CGPA
    for file in subjects/*.txt; do
        if grep -q "^$roll_no:" "$file"; then
            grade=$(grep "^$roll_no:" "$file" | cut -d':' -f3)
            gpa=$(grade_to_gpa "$grade")
            total_gpa=$(echo "$total_gpa + $gpa" | bc)
            ((subject_count++))
        fi
    done

    # If subjects found, calculate the average CGPA, else mark as N/A
    if (( subject_count > 0 )); then
        cgpa=$(echo "scale=2; $total_gpa / $subject_count" | bc)
    else
        cgpa="N/A"
    fi

    # Update CGPA file with the new CGPA
    sed -i "/^$roll_no:/d" cgpa.txt
    echo "$roll_no:$cgpa" >> cgpa.txt
    # Display updated CGPA
    echo "🎓 Updated CGPA for Roll No: $roll_no is $cgpa"
}

# Function to validate the student roll number
validate_roll_number() {
    # Prompt for the roll number input
    read -p "Enter Student Roll Number: " roll_no
    # Check if the roll number exists in students.txt
    if ! grep -q "^$roll_no:" students.txt; then
        echo "❌ Error: Roll Number '$roll_no' not found in students.txt!"
        return 1  # Return 1 if not found
    fi
    echo "$roll_no"  # Return the valid roll number
}

# Function to add or update grades for a specific subject
add_grades() {
    # Display available subjects to the user
    echo "📌 Available Subjects: Math, Physics, Programming"
    
    # Prompt the user to enter the name of the subject
    read -p "Enter subject name: " subject
    
    # Convert the subject name to lowercase and use it to create the subject file
    subject_file="subjects/${subject,,}.txt"

    # Create the 'subjects' directory if it doesn't exist
    mkdir -p subjects  # Ensure the subjects directory exists
    
    # Create the subject file if it doesn't exist (e.g., subjects/math.txt)
    touch "$subject_file"  # Create subject file if it doesn't exist

    # Call the validate_roll_number function to ensure the entered Roll No. is valid
    roll_no=$(validate_roll_number)
    
    # If the roll number is invalid, abort the function
    if [[ $? -ne 0 || -z "$roll_no" ]]; then  
        echo "❌ Operation aborted due to invalid Roll Number."  # Show error message
        return  # Exit the function if the Roll No. is invalid
    fi

    # Prompt the user to enter the marks for the specified subject
    read -p "Enter Marks: " marks
    
    # Calculate the grade corresponding to the entered marks
    grade=$(calculate_grade "$marks")

    # Check if the student's roll number already exists in the subject file
    if grep -q "^$roll_no:" "$subject_file"; then
        # If the roll number exists, update the existing record with new marks and grade
        sed -i "s/^$roll_no:.*/$roll_no:$marks:$grade/" "$subject_file"
        echo "✅ Updated marks & grade for Roll No: $roll_no in $subject"  # Success message for updating
    else
        # If the roll number doesn't exist, add a new entry with marks and grade
        echo "$roll_no:$marks:$grade" >> "$subject_file"
        echo "✅ Added marks & grade for Roll No: $roll_no in $subject"  # Success message for adding
    fi

    # Call the calculate_cgpa function to update the CGPA of the student after the grade change
    calculate_cgpa "$roll_no"
}


#run the function

add_grades
