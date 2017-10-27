#!/bin/bash
listFile=$1 #requires a text file to itterate through
#syntax: ./copy_content.sh content_lists/audio_files.txt

relativePath="$(cd "$(dirname "$1")"; pwd)/"
#Itterate through the listfile and perform the cp command 
#based on the data per line in the file

function moveFiles() {
  echo "Copying files"
  touch paths.txt
  pathsFile=paths.txt
  
  while IFS='' read -r line
  do
    echo 'LINE VALUE: $line';
  done < $listFile
  
}

moveFiles