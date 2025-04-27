#!/bin/bash

#allows the teacher to view grades subject-wise
#the teacher inputs subject, it the subject file exists then it retrieves the grades, otherwise it shows an error message

view_grades() {
    echo "📌 Available Subjects: Math, Physics, Programming"
    read -p "Enter subject name: " subject
    subject_file="subjects/${subject,,}.txt"  

    if [[ ! -f "$subject_file" ]]; then
        echo "❌ No grades recorded for $subject yet."
        return
    fi

    echo "📊 Grades for $subject:"
    column -t -s ":" "$subject_file"
}

view_grades
