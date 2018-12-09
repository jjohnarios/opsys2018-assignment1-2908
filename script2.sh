tar zxf "$1" --warning=no-timestamp

#finds 1rst https.. in every text file in current pwd(.)
text=$(find . -type f -name "*.txt" -exec grep -m 1 '^https' {} \;)
#creates folder if not exists
if [ ! -d "assignments" ]; 
then
	mkdir assignments
fi

repositories="" # string for each repo in a new line
count=0 #counter used for displaying
while read -r line; 
do
	cd assignments
	count=$((count+1))
	git clone  "$line" "repo$count" > /dev/null 2> /dev/null
	if [ "$?" == "0" ]; then
	   echo "$line" "Cloning OK"
	   repositories="$repositories repo$count"
	   newline=$'\n'
	   repositories="$repositories $newline"
	else
	   echo "$line" "Cloning FAILED"
	fi
	cd ..
done <<< "$text"


while read -r line;
do
      if [ ! "$line" == "" ]; #skips last empty Line
      then
	

	cd "assignments/$line"
	echo "$line :"
        numberOfDirs=$(find . -mindepth 1 -type d | grep -v './\.' | wc -l)
	otherFiles=$(find . -mindepth 1 -type f ! -name '*.txt' | grep -v './\.' | wc -l)
	txtFiles=$(find . -mindepth 1 -type f -name '*.txt' | grep -v './\.' | wc -l)
	echo "Number of directories: $numberOfDirs "
	echo "Number of txt files:  $txtFiles"
	echo "Number of other files: $otherFiles "
	
	touch structureFile
	find . -mindepth 1 -maxdepth 1 -type f -name 'dataA.txt' >> structureFile
	find . -type d -name "more" | find . -mindepth 2 -maxdepth 2 -type f  \( -name 'dataB.txt' -o  -name 'dataC.txt' \)  >> structureFile
	content=$( cat structureFile )
	check="./dataA.txt$newline./more/dataB.txt$newline./more/dataC.txt"
	if [  "$content" == "$check" ]
	then
		
		if [ "$otherFiles" == "0" -a "$numberOfDirs" == "1" -a "$txtFiles" == "3" ]
		then
	   	    echo "Directory is OK"
		 
                else
	            echo "Directory is NOT OK" 
                fi
        else 
           echo "Directory is NOT OK" 
	fi
	cd ../..
       fi

done <<< "$repositories"


parameterFileName=$( echo "$1" | cut -d. -f1)

rm -rf "$parameterFileName" #removes untarred directory
rm -rf assignments #removes assignments directory

