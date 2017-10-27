#!/bin/bash
listFile=$1 #requires a text file to itterate through
#syntax: ./copy_content.sh content_lists/audio_files.txt

relativePath="$(cd "$(dirname "$1")"; pwd)/"
#Itterate through the listfile and perform the cp command 
#based on the data per line in the file

function moveFiles() {
  echo "Copying files"
  
  if [[ -f copy_errors.txt ]];
  then 
    rm copy_errors.txt
  fi
  
  while IFS='' read -r line
  do
    cp $line;
    if [[ "$?" != "0" ]];
    then
      touch copy_errors.txt;
      echo "An error occured when copying this: $line" >> copy_errors.txt;
    fi
    echo "Copied $line";
  done < "$listFile"
  
}

moveFiles