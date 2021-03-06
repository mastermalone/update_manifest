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
    echo "file0.mp3 4589713" >> $manifestFile >> index #REMOVE TODO
    while IFS='' read -r lineitem
    do
    	echo "LINE ITEM $lineitem";
      if [[ -s $manifestFile && "$lineitem" =~ "$filename" ]];
      then
        echo "Found a match!: $lineitem";
        #lineNumber=`expr $lineNumber + 1`;
        #replaceText=$lineitem | sed 's/$lineitem/$filename/';
        
        #sed  -ie "/\b\($lineitem\|$lineitem\)\b/d" $manifestFile && echo $filename >> $manifestFile #SEEMS TO WORK
        #sed -i ' ' -e "/\b\($lineitem\|$lineitem\)\b/d" $manifestFile && echo $filename >> $manifestFile #SEEMS TO WORK
        #sed -i ' ' -e "/\b\($lineitem\([0-9.])\|$lineitem\(\))\b/d" $manifestFile #&& echo $filename >> $manifestFile #TEST1
        #sed -e "/\b\($lineitem\|$lineitem\)\b/d" $manifestFile && echo $filename >> $manifestFile #SEEMS TO WORK
				#echo $lineitem | sed -ie  's/$lineitem/$filename/g' * > $manifestFile; #NOT WORKING
				nonCheckSum=$(echo $filename | sed 's/$lineitem/$filename/');
				#sed  '/^$lineitem/d'  $manifestFile
        #awk '!/$lineitem/d' > $manifestFile && echo $filename >> $manifestFile #DELETES ALL BUT THE REPLACED LINE TODO
				#UPDATE
				awk '!/$filename/{ if ($2 ~ /[0-9]/) print }1' $manifestFile  && echo $filename >> $manifestFile 
				break;
				#echo "Line Item $lineitem";
        #echo "WTH, MAN 8966547" >> $manifestFile
        
        #echo $lineitem | sed 's/$lineitem/$filename/' >$manifestFile;
        #echo "test123" | sed 's/123/321/' >$manifestFile;
				lineNumber=0;
      else
      	#FOR TESTING ONLY!!! TODO
        echo "Creating new entry for $filename";        
        echo "file1.mp3 4589757" >> $manifestFile
        echo $filename "1234569" >> $manifestFile;
        echo "file2.mp3 8966547" >> $manifestFile
        echo "test100.mp3 8966547" >> $manifestFile
        echo "test5.png 8966547XXX" >> $manifestFile
        break;
        #replaceText=$lineitem | sed 's/$lineitem/$filename/';
        #echo $filename | tee -a "index" #GOOD
      fi
    done < "$manifestFile"
    echo $dir_name
    
  done < "$updateTextFile"
   
}

#moveFiles
update_manifest


