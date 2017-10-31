#!/bin/bash
listFile=$1 #requires a text file to itterate through
#syntax: ./copy_content.sh content_lists/audio_files.txt

relativePath="$(cd "$(dirname "$1")"; pwd)/"
#Iterate through the listfile and perform the cp command based on the data per line in the file

function moveFiles() {
  echo "Copying files";
  totalFiles=0;
  copiedFiles=0;
  
  if [[ -f copy_errors.txt ]];
  then 
    rm copy_errors.txt
  fi
  
  if [[ -f copied_audio_file_results.txt ]];
  then
  	rm copied_audio_file_results.txt;
  fi
  
  while IFS='' read -r line
  do
    totalFiles=`expr $totalFiles + 1`; #count for total files listed in the listFile.txt
		cp $line;
    if [[ $? -ne 0 ]];
    then
			touch copy_errors.txt;
      echo "An error occured when copying this: $line.  No such file exists." >> copy_errors.txt;
    else
    	copiedFiles=`expr $copiedFiles + 1`; #count of total copied files
			touch copied_audio_file_results.txt
			echo "Copied $line";
			echo "Copied $line" >> copied_audio_file_results.txt;
    fi
  done < "$listFile"
  wait
  echo "The process has finished.  There were $copiedFiles files out $totalFiles copied";
}

moveFiles