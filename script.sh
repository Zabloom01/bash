#!/bin/bash

# A common use of bash scripts is for releasing a "build" of your source code.

echo "Welcome! Let's build the source code!"

# Verify user has updated changelog.md with the current release version
# Use the head utility to extract the first line of the file from the path source/changelog.md.
# By default head returns 10 lines, but -n helps us specify the number of lines we want
firstline=$(head -n 1 source/changelog.md)
# Split firstline into an array and assign it to splitfirstline. Note, <<< is a here string
read -a splitfirstline <<< "$firstline" # Read input from stream - read can either read from a stream or take an input from a user

# Access value of index 1 and assign version to variable 'version'
version=${splitfirstline[1]}
echo "You are building version $version"

# Give the user a chance to exit the script if they need to make a version change
# If user enters "1" (for yes) continue, else "0" (for no) to exit
echo 'Do you want to continue? (enter "1" for yes, "0" for no)'
read versioncontinue # record user input
if [ "$versioncontinue" -eq 1 ]; then # Note this if statement is functionally equivalent to the later if statement.  Either style works
  echo "OK"
else
  echo "Please come back when you are ready"
  exit 0 # Exit the script
fi

# Create build directory if it doesn't exist
mkdir -p build

# Copy every file from source to build, skipping source/secretinfo.md
echo "Copying files from source to build..."
for filename in source/*; do # Asterisk (*) means it will look at all files in the source directory
  if [ "$filename" == "source/secretinfo.md" ] # Note this if statement is functionally equivalent to the prior if statement, either style works
  then
    echo "Skipping file: $filename" # skip file, does not copy to build directory
  else
    echo "Copying file: $filename"
    cp "$filename" build/ || { echo "Failed to copy $filename"; exit 1; }
  fi
done

# List files in the build directory to confirm file transfer was successful
echo "Files in the build directory:"
# list the build files.
ls build/
