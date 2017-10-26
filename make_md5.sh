#!/bin/bash
updateTextFile=$1 #requires a text file to itterate through
#syntax: ./make_md5.sh manifestFileUpdate.txt 

relativePath="$(cd "$(dirname "$1")"; pwd)/"
#First, move all the files to their locations
#create a list of the paths where all of the files were copied to
#From that list, find the manifest files that contain references to the new
#copied, renamed files and update the manifest file

function moveFiles() {
  echo "Copying files"
  touch paths.txt
  pathsFile="paths.txt"
  echo artwork/snd/color/images/2017_mlk_test.mp3 artwork/snd/curriculum/description/12344.mp3 | tee -a "$pathsFile"
  echo artwork/snd/color/images/2017_mlk_test1.mp3 artwork/snd/curriculum/description/12345.mp3 | tee -a "$pathsFile"
  echo artwork/snd/color/images/2017_mlk_test2.mp3 artwork/snd/curriculum/description/12346.mp3 | tee -a "$pathsFile"
  echo artwork/snd/color/images/2017_mlk_test3.mp3 artwork/snd/curriculum/description/12347.mp3 | tee -a "$pathsFile"
  echo artwork/snd/color/images/2017_mlk_test4.mp3 artwork/snd/curriculum/description/12348.mp3 | tee -a "$pathsFile"
  
  #echo artwork/snd/curriculum/description/12344.mp3 | tee "$pathsFile"
  
  echo "Files Copied to artwork/snd/curriculum/description/$pathsFile"
}

function update_manifest() {
  #echo $updateTextFile
  
  while IFS='' read -r line
  do
    #cd $(dirname $(readlink -f $0))/$line
    #cd $relativePath$line #GOOD
    #echo $line
    #echo $(dirname $(readlink -f $0))/$line
    #echo $relativePath$line
    #touch index
    #echo $line | tee -a "index" #GOOD
    
    fspec=$relativePath$line #The full path of the file 
    filename="${fspec##*/}"  # get filename
    dir_name="${fspec%/*}" # get directory/path name
    file_extention="mp3"
    cd $dir_name
    
    rm index
    touch index
    manifestFile=index
    echo "" >> index #REMOVE TODO
    
    while IFS='' read -r lineitem
    do
      if [[ -s $manifestFile && "$lineitem" =~ "$filename" ]];
      then
        echo "Found a match!: $lineitem";
        #replaceText=$lineitem | sed 's/$lineitem/$filename/';
        #echo $lineitem | sed '/$lineitem/d' >$manifestFile;
        lineNumber=$(awk '/$filename/{print NR}' $manifestFile); #NOT WORKING RIGHT TODO
        #echo $lineNumber
        #echo "WTH, MAN 4589757" >> $manifestFile
        sed -i "/\b\($lineitem\|$lineitem\)\b/d" $manifestFile && echo $filename >> $manifestFile #SEEMS TO WORK
        #awk '!/$lineitem/d' > $manifestFile && echo $filename >> $manifestFile #DELETES ALL BUT THE REPLACED LINE TODO
        #echo "WTH, MAN 8966547" >> $manifestFile
        
        #echo $lineitem | sed 's/$lineitem/$filename/' >$manifestFile;
        #echo "test123" | sed 's/123/321/' >$manifestFile;
      else
        echo "Creating new entry for $filename";
        #echo "Dummy" >> $manifestFile;
        echo "WTH, MAN 4589757" >> $manifestFile
        echo $filename "1234569" >> $manifestFile;
        echo "WTH, MAN 8966547" >> $manifestFile
        #replaceText=$lineitem | sed 's/$lineitem/$filename/';
        #echo $filename | tee -a "index" #GOOD
      fi
    done < "$manifestFile"
    echo $dir_name
    
  done < "$updateTextFile"
   
}

#moveFiles
update_manifest


