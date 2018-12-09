getCon() {
	 content=$(wget $i -q -O - )
        ret=$?
        t="$i"
        t=${t##*\//} 
        t="${t////\\}" #change / to \ ( / -> \)
	if [ ! -f "$t".txt ] ;
	then
		if [ "$ret" == "0" ];
		then
			echo "$i INIT"
			touch "$t".txt
                        echo "$content" > "$t".txt
		else
			touch "$t".txt
		        echo ""> "$t".txt
		        echo " $i FAILED "
		fi	 	
	else
		if [ "$ret" == "0" ];
		then
			temp="$content"
			previous=`cat "$t".txt`
			if [ ! "$temp" == "$previous" ]; #if they differ
			then
				echo "$temp" > "$t".txt
                                echo " $i "
                         fi
		else
			if [ ! "$content" == "" ];
			then
				echo "$content" > "$t".txt
				echo " $i "
			fi
		fi
	fi
}

grep  "^[^#*]" $1 > websites.txt
while read i; do getCon i & done < websites.txt
wait
