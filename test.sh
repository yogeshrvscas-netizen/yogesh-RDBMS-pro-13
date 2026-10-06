#!/bin/bash

set -e

echo "======================================"
echo "Lab Program 13 - 3NF Autograding"
echo "======================================"

DB="CollegeDB"
MYSQL="mysql -h 127.0.0.1 -u root -proot"

echo ""
echo "Loading original schema..."
$MYSQL < schema.sql

echo "Running student solution..."
$MYSQL "$DB" < solution.sql

PASS=0
FAIL=0

check() {
    TEST_NAME="$1"
    SQL="$2"
    EXPECTED="$3"

    RESULT=$($MYSQL -N -s "$DB" -e "$SQL" | tr -d '\r' | xargs)

    if [ "$RESULT" = "$EXPECTED" ]; then
        echo "PASS: $TEST_NAME"
        PASS=$((PASS+1))
    else
        echo "FAIL: $TEST_NAME"
        echo "  Expected: $EXPECTED"
        echo "  Actual:   $RESULT"
        FAIL=$((FAIL+1))
    fi
}

check "Department table exists" \
"SELECT COUNT(*) FROM information_schema.tables
 WHERE table_schema='$DB' AND table_name='Department';" "1"

check "Faculty table exists" \
"SELECT COUNT(*) FROM information_schema.tables
 WHERE table_schema='$DB' AND table_name='Faculty';" "1"

check "Course table exists" \
"SELECT COUNT(*) FROM information_schema.tables
 WHERE table_schema='$DB' AND table_name='Course';" "1"

check "Student table exists" \
"SELECT COUNT(*) FROM information_schema.tables
 WHERE table_schema='$DB' AND table_name='Student';" "1"

check "Department primary key exists" \
"SELECT COUNT(*) FROM information_schema.table_constraints
 WHERE table_schema='$DB'
 AND table_name='Department'
 AND constraint_type='PRIMARY KEY';" "1"

check "Faculty primary key exists" \
"SELECT COUNT(*) FROM information_schema.table_constraints
 WHERE table_schema='$DB'
 AND table_name='Faculty'
 AND constraint_type='PRIMARY KEY';" "1"

check "Course primary key exists" \
"SELECT COUNT(*) FROM information_schema.table_constraints
 WHERE table_schema='$DB'
 AND table_name='Course'
 AND constraint_type='PRIMARY KEY';" "1"

check "Student primary key exists" \
"SELECT COUNT(*) FROM information_schema.table_constraints
 WHERE table_schema='$DB'
 AND table_name='Student'
 AND constraint_type='PRIMARY KEY';" "1"

check "Faculty has Department foreign key" \
"SELECT COUNT(*) FROM information_schema.key_column_usage
 WHERE table_schema='$DB'
 AND table_name='Faculty'
 AND referenced_table_name='Department';" "1"

check "Course has Faculty foreign key" \
"SELECT COUNT(*) FROM information_schema.key_column_usage
 WHERE table_schema='$DB'
 AND table_name='Course'
 AND referenced_table_name='Faculty';" "1"

check "Student has Course foreign key" \
"SELECT COUNT(*) FROM information_schema.key_column_usage
 WHERE table_schema='$DB'
 AND table_name='Student'
 AND referenced_table_name='Course';" "1"

check "Student does not contain FacultyName" \
"SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema='$DB'
 AND table_name='Student'
 AND column_name='FacultyName';" "0"

check "Student does not contain DepartmentName" \
"SELECT COUNT(*) FROM information_schema.columns
 WHERE table_schema='$DB'
 AND table_name='Student'
 AND column_name='DepartmentName';" "0"

check "Student sample data exists" \
"SELECT COUNT(*) FROM Student;" "4"

check "Department sample data exists" \
"SELECT COUNT(*) FROM Department;" "2"

echo ""
echo "======================================"
echo "RESULT"
echo "======================================"
echo "Passed : $PASS"
echo "Failed : $FAIL"

if [ "$FAIL" -eq 0 ]; then
    echo "ALL TEST CASES PASSED"
    exit 0
else
    echo "SOME TEST CASES FAILED"
    exit 1
fi
