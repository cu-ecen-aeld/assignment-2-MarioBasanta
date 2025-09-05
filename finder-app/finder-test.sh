#!/bin/sh
# Tester script for assignment 1 and assignment 2
# Author: Mario Basanta Marchan
# Modified for Assignment 2 to use compiled writer.c

set -e
set -u

NUMFILES=10
WRITESTR=AELD_IS_FUN
WRITEDIR=/tmp/aeld-data
BASEDIR=$(dirname "$0")/..
username=$(cat conf/username.txt)

if [ $# -lt 3 ]
then
	echo "Using default value ${WRITESTR} for string to write"
	if [ $# -lt 1 ]
	then
		echo "Using default value ${NUMFILES} for number of files to write"
	else
		NUMFILES=$1
	fi	
else
	NUMFILES=$1
	WRITESTR=$2
	WRITEDIR=/tmp/aeld-data/$3
fi

MATCHSTR="The number of files are ${NUMFILES} and the number of matching lines are ${NUMFILES}"

echo "Writing ${NUMFILES} files containing string ${WRITESTR} to ${WRITEDIR}"

rm -rf "${WRITEDIR}"

# Create WRITEDIR if not assignment1
assignment=$(cat conf/assignment.txt)


if [ "$assignment" != "assignment1" ]; then
	mkdir -p "$WRITEDIR"
	if [ -d "$WRITEDIR" ]; then
		echo "$WRITEDIR created"
	else
		echo "Failed to create $WRITEDIR"
		exit 1
	fi
fi

# Clean old builds
echo "Cleaning previous build artifacts..."
make -C "$BASEDIR" clean

#  Build native writer application
echo "Building writer application (native build)..."
make -C "$BASEDIR"

# Use compiled writer instead of writer.sh
for i in $(seq 1 $NUMFILES); do
	"$BASEDIR/finder-app/writer" "$WRITEDIR/${username}$i.txt" "$WRITESTR"
done

# Now do the equivalent of finder.sh: count files and matching lines
num_files=$(find "$WRITEDIR" -type f | wc -l)
num_matches=$(grep -r "$WRITESTR" "$WRITEDIR" | wc -l)

OUTPUTSTRING="The number of files are ${num_files} and the number of matching lines are ${num_matches}"

# Cleanup
rm -rf /tmp/aeld-data

set +e
echo "$OUTPUTSTRING" | grep "${MATCHSTR}" > /dev/null
if [ $? -eq 0 ]; then
	echo "success"
	exit 0
else
	echo "failed: expected '${MATCHSTR}' in '${OUTPUTSTRING}'"
	exit 1
fi

