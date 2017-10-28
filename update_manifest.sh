#!/bin/bash
updateTextFile=$1 #requires a text file to itterate through
#syntax: ./update_manifest.sh art_manifest_update.txt

relativePath="$(cd "$(dirname "$1")"; pwd)/"

function update_manifest() {
  #echo $updateTextFile
  
  if [[ -f m_update_results.txt ]];
  then
  	rm m_update_results.txt
  fi
  
  touch m_update_results.txt;
  m_u_results=m_update_results.txt;
	updatedFileCount=0;
  
  while IFS='' read -r line
  do
    fspec=$relativePath$line; #The full path of the file 
    filename="${fspec##*/}";  # get filename
    dir_name="${fspec%/*}"; # get directory/path name
    manifestFile=index;
    
    cd $dir_name; 
    
    echo $filename >> $manifestFile;
    echo "Successfully added $filename to $dir_name/init" >> $relativePath$m_u_results;
    echo "Adding $filename";
    updatedFileCount=`expr $updatedFileCount + 1`
  done < "$updateTextFile"
  wait 
  echo "The process has finished.  There were/was $updatedFileCount file/s have been updated.";
}

update_manifest