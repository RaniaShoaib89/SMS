#!/bin/bash

declare -A grade_points=( ["A"]=4.0 ["B"]=3.0 ["C"]=2.0 ["D"]=1.0 ["F"]=0.0 )

calculate_cgpa() {
    roll_no=$1
    total_points=0
    subject_count=0

    for file in subjects/*.txt; do
        grade=$(grep "^$roll_no:" "$file" | cut -d':' -f3)
        if [[ -n $grade ]]; then
            total_points=$(echo "$total_points + ${grade_points[$grade]}" | bc)
            ((subject_count++))
        fi
    done

    if (( subject_count > 0 )); then
        cgpa=$(echo "scale=2; $total_points / $subject_count" | bc)
        echo "$roll_no:$cgpa"
    fi
}

echo "📌 Calculating CGPA for all students..."
temp_file=$(mktemp)

while IFS=":" read -r roll_no _; do
    calculate_cgpa "$roll_no" >> "$temp_file"
done < students.txt

mv "$temp_file" cgpa.txt
echo "✅ CGPA stored in cgpa.txt"
