#!/bin/bash

# Function to convert grades to GPA
grade_to_gpa() {
    # Convert grade to corresponding GPA using a case statement
    case "$1" in
        A+) echo 4.0 ;;
        A) echo 3.7 ;;
        A-) echo 3.5 ;;
        B+) echo 3.3 ;;
        B) echo 3.0 ;;
        B-) echo 2.7 ;;
        C+) echo 2.5 ;;
        C) echo 2.0 ;;
        C-) echo 1.7 ;;
        D) echo 1.0 ;;
        F) echo 0.0 ;;
        *) echo 0.0 ;;  # Default case if invalid grade
    esac
}

# Get the list of all subjects (file names without the .txt extension) in the 'subjects' directory
subjects=($(ls subjects | sed 's/.txt//g'))

# Function to generate the student report
generate_report() {
    echo "📊 Student Report"
    echo "-----------------------------------------------------------------"
    
    # Print the header row with subject names and columns for Avg, CGPA, and Status
    printf "%-12s" "Roll No"
    for subject in "${subjects[@]}"; do
        printf " %-8s" "$subject"
    done
    printf " %-8s %-8s %-8s\n" "Avg" "CGPA" "Status"
    echo "-----------------------------------------------------------------"

    # Read each roll number from the 'students.txt' file
    while IFS=":" read -r roll_no _; do
        grades=()  # Array to store grades for each subject
        total_gpa=0  # Initialize total GPA
        subject_count=0  # Initialize subject count

        # Loop through each subject to calculate the GPA
        for subject in "${subjects[@]}"; do
            file="subjects/${subject}.txt"  # Path to subject file
            if grep -q "^$roll_no:" "$file"; then  # Check if Roll No. exists in the subject file
                grade=$(grep "^$roll_no:" "$file" | cut -d':' -f3)  # Get the grade for this subject
                grades+=("$grade")  # Add the grade to the grades array
                gpa=$(grade_to_gpa "$grade")  # Convert grade to GPA
                total_gpa=$(echo "$total_gpa + $gpa" | bc)  # Accumulate GPA
                ((subject_count++))  # Increment subject count if grade is found
            else
                grades+=("N/A")  # If no grade, add "N/A" for that subject
            fi
        done

        # Calculate the average GPA if subjects are found
        if (( subject_count > 0 )); then
            avg_gpa=$(echo "scale=2; $total_gpa / $subject_count" | bc | awk '{printf "%.2f", $0}')
        else
            avg_gpa="N/A"  # If no subjects, set average GPA to "N/A"
        fi

        # Get the CGPA from the cgpa.txt file for the roll number
        cgpa=$(grep "^$roll_no:" cgpa.txt | cut -d':' -f2)
        [[ -z "$cgpa" ]] && cgpa="N/A" || cgpa=$(printf "%.2f" "$cgpa" 2>/dev/null)  # If no CGPA, set to "N/A"

        # Determine if the student has passed based on CGPA (>= 2.0)
        if [[ "$cgpa" != "N/A" && $(echo "$cgpa >= 2.0" | bc) -eq 1 ]]; then
            status="✅ Pass"
        else
            status="❌ Fail"
        fi

        # Print the student's roll number, grades, average GPA, CGPA, and status
        printf "%-12s" "$roll_no"
        for grade in "${grades[@]}"; do
            printf " %-8s" "$grade"
        done
        printf " %-8s %-8s %-8s\n" "$avg_gpa" "$cgpa" "$status"
    done < students.txt  # Read students.txt to get all the roll numbers

    echo "-----------------------------------------------------------------"

    # Prompt the user for sorting options for CGPA
    echo -e "\n📌 Sorting Options:"
    echo "1. Ascending Order (CGPA)"
    echo "2. Descending Order (CGPA)"
    read -p "Select an option: " option

    # Sort the CGPA file based on user's choice
    case "$option" in
        1) sort -t: -k2 -n cgpa.txt ;;  # Sort in ascending order by CGPA
        2) sort -t: -k2 -nr cgpa.txt ;;  # Sort in descending order by CGPA
        *) echo "❌ Invalid choice!" ;;  # Display error if invalid option
    esac
}

#run the function
generate_report


