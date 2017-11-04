#!/bin/bash
updateListTextFile=$1 #requires a text file to itterate through
#syntax: ./update_manifest.sh art_manifest_update.txt

relativePath="$(cd "$(dirname "$1")"; pwd)/"

function update_manifest() {
  
  if [[ -f m_update_results.txt ]];
  then
  	rm m_update_results.txt
  fi
  
	if [[ -f m_update_errors.txt ]];
	then
		rm m_update_errors.txt;
	fi
  
  touch m_update_results.txt;
  m_u_results=m_update_results.txt;
	updatedFileCount=0;
	totalFileCount=0;
	existingEntryUpdated=false;
  
  #Read the updateListTextFile and loop through line by line
  while IFS='' read -r line
  do
    fspec=$relativePath$line; #The full path of the file 
    filename="${fspec##*/}";  # get filename
    dir_name="${fspec%/*}"; # get directory/path name
    
    #cd $dir_name; 
    if [[  -d $dir_name ]]; #If the directory exists, go to it
    then 
    	#Go to the diectory listed in the loaded text file
    	cd $dir_name; 
			#If the index file is located in the directory, proceed
			if [[ -f index ]]; 
			then
				
				#while IFS='' read mLine
				while IFS='' read -r mLine || [[ -n "$mLine" ]];
				do
					#echo "THE MLINE $mLine.";
					#Read the index file line by line and look for a match for the string in the filename variable
					if [[ "$mLine" =~ "$filename" ]];
					then
						echo "Found a match for $filename.";
						echo "Found on line $mLine.";
						echo "";
						sed -i '' "s/$mLine/$filename/" index; #Replace inline
						existingEntryUpdated=true;
						wait
					fi
					
					#Reached the End Of FIle (EOF)
					if  [[ -z "$mLine" ]];
					then
						echo "EOF.  An existing entry was updated?: $existingEntryUpdated";
					fi
				done < index
				wait
				
				
				#echo $filename >> index; #Add the file name to the end of the index file
    		#echo "Successfully added $filename to $dir_name/init" >> $relativePath$m_u_results;
    		#echo "Adding $filename to ($dir_name/index)";
    		#updatedFileCount=`expr $updatedFileCount + 1`;
			else
				#Create and error file and write the errors to it.
				touch m_update_errors.txt;
				manifestErrors=m_update_errors.txt;
				echo "An error occured.  The index file for ($dir_name/) does not exist." ;
  			echo "An error occured.  The index file for ($dir_name/) does not exist." >> $relativePath$manifestErrors;
			fi
    else
    	touch m_update_errors.txt;
  		echo "An error occured.  The following directory does not exist: $dir_name/" >> m_update_errors.txt
    fi
    
    totalFileCount=`expr $totalFileCount + 1`
  done < "$updateListTextFile"
  wait 
  echo "The process has finished.  There were $updatedFileCount out of $totalFileCount index files updated.";
}

update_manifest