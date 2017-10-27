#!/bin/bash
updateTextFile=$1 #requires a text file to itterate through
#syntax: ./update_manifest.sh art_manifest_update.txt

relativePath="$(cd "$(dirname "$1")"; pwd)/"

function update_manifest() {
  #echo $updateTextFile
  touch m_update_results.txt;
  m_u_results=m_update_results.txt;
  
  while IFS='' read -r line
  do
    fspec=$relativePath$line; #The full path of the file 
    filename="${fspec##*/}";  # get filename
    dir_name="${fspec%/*}"; # get directory/path name
    manifestFile=index;
    
    cd $dir_name; #TODO Remove the back dir
    
    echo $filename >> $manifestFile;
    echo "Successfully added $filename to $dir_name/init" >> $relativePath$m_u_results;
    echo "Adding $filename";
    
  done < "$updateTextFile"
}

update_manifest