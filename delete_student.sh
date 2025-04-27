#!/bin/bash

#prompts the teacher to enter roll-number
#if available, then removes student from student.txt file and also from all subject file(if any), displays message if removed successfully
#else, displays error message

delete_student() {
    read -p "Enter the Roll Number of the student to delete: " roll_no

    # Check if the student exists
    if ! grep -q "^$roll_no:" students.txt; then
        echo "❌ Student with Roll No $roll_no not found!"
        return
    fi

   
    sed -i "/^$roll_no:/d" students.txt
    echo "✅ Student $roll_no removed from students.txt"

   
    for file in subjects/*.txt; do
        sed -i "/^$roll_no:/d" "$file"
    done

    echo "✅ Grades for student $roll_no deleted from all subjects."
}

delete_student
