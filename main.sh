#!/bin/bash


main_menu() {
    while true; do
        clear
        echo "🔹 Student Management System 🔹"
        echo "1. Login as Teacher"
        echo "2. Login as Student"
        echo "3. Exit"
        read -p "Select an option: " option

        case $option in
            1) login "teacher" ;;   
            2) login "student" ;;
            3) exit 0 ;;  # Exit the program cleanly
            *) echo "❌ Invalid option. Try again." && sleep 1 ;;
        esac
    done
}



login() {
    user_type=$1
    read -p "Enter username (Roll No for students): " username
    read -s -p "Enter password: " password
    echo

   
    if [[ "$user_type" == "teacher" ]]; then
        auth_file="teachers.txt"
    else
        auth_file="students.txt"
    fi

    
    if grep -q "^$username:$password$" "$auth_file"; then
        echo "✅ Login successful!"
        sleep 1
        if [[ "$user_type" == "teacher" ]]; then
            teacher_menu
        else
            student_menu "$username"
        fi
    else
        echo "❌ Incorrect credentials! Try again."
        sleep 1
        main_menu
    fi
}


teacher_menu() {
    while true; do  
        clear
        echo "📚 Teacher Dashboard"
        echo "1. Add Student"
        echo "2. Delete Student"
        echo "3. Manage Grades"
        echo "4. View Student Report"
        echo "5. View Passed & Failed Students"
        echo "6. Search Student"
        echo "7. View Grades (All Subjects)"
        echo "8. Logout"
        read -p "Select an option: " choice

        case $choice in
            1) ./add_student.sh ;;  
            2) ./delete_student.sh ;;  
            3) ./manage_grades.sh ;;  
            4) ./generate_report.sh ;;  
            5) ./list_students.sh ;;  
            6) ./search_student.sh ;;  
            7) ./view_grades.sh ;;  
            8) return ;;  # Go back to main menu
            *) echo "❌ Invalid choice!" && sleep 1 ;;
        esac
         read -p "Press Enter to continue..."
    done
}


student_menu() {
    roll_no=$1
    while true; do  
        clear
        echo "📖 Student Dashboard (Roll No: $roll_no)"
        echo "1. View Results (Grades & CGPA)"
        echo "2. Logout"
        read -p "Select an option: " choice

        case $choice in
            1) ./view_results.sh "$roll_no" ;;  
            2) return ;;  # Go back to main menu
            *) echo "❌ Invalid option. Try again!" && sleep 1 ;;
        esac
         read -p "Press Enter to continue..."
    done
}



main_menu

