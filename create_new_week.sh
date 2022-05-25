#!/bin/bash

#If there are no input arguments ask the user for a year-weeknumber
if [ $# -eq 0 ]
 then
	echo "Provide year-weeknumber, the current year-week is `date +%Y`-`date +%W`:"
	read yn_wn
else
	yn_wn = $1
fi

echo "Making directory ${yn_wn}."
mkdir $yn_wn

echo "Creating update latex file in the ${yn_wn} dir."
cp update_template.tex $yn_wn
mv $yn_wn/update_template.tex $yn_wn/update_$yn_wn.tex

echo "Creating Figures folder in the ${yn_wn} dir."
mkdir $yn_wn/Figures

# parse the year and week from the user input
arrYN_WN=(${yn_wn//-/ })
year=${arrYN_WN[0]}
week=${arrYN_WN[1]}

# Find last update meeting. Could also have done a search on the directory to find the 
# latest update meeting via folder name. 
echo "Searching for last update meeting"
prev_update="none"
while [ "$prev_update" = "none" ]
do
	week=$(($week-1))
	if [ $week == 0 ]
	 then 
		week=52
		year=$(($year - 1))
		echo "checking for year ${year}"
		if [ $year -lt 2022 ]
		 then
			echo "No previous directory found, press enter to exit"
			read stop_var
			exit 125
		fi
	fi
	if [ -d "${year}-${week}" ]
		then
			prev_update="${year}-${week}"
	fi
done
echo "The last update meeting found was ${prev_update}"

## Transfer uncompleted todos to the new update file.
# Remove the template todo section
echo "Transfering uncompleted todos to ${yn_wn}/update_${yn_wn}.tex."
sed -i '/%BT/,/%ET/{/%BT/!{/%ET/!d}}' $yn_wn/update_$yn_wn.tex

## Insert the ToDo's from the last update meeting 
total_todos=-2  #To account for the begin outline tags
active_todos=-2 #To account for the begin outline tags
copy=false
input="${prev_update}/update_${prev_update}.tex"
while IFS= read -r line
do	
	if [[ "$line" =~ .*"%ET".* ]]
	 then 
		copy=false
	fi
	
	if $copy
	 then
		total_todos=$((total_todos+1))
		if [[ $line != *"\strike["* ]]
			then
				line=$(echo "$line" | sed 's;\\;\\\\\\;g')
				sed -i '/^%ET/i '"$line" $yn_wn/update_$yn_wn.tex
				active_todos=$((active_todos+1))
		fi
		
	fi
	
	if [[ "$line" =~ .*"%BT".* ]]
	 then 
		copy=true
	fi
done < "$input"
completed_todos=$((total_todos-active_todos))
echo "Out of ${total_todos} todos you have completed ${completed_todos}!"
echo "DONE, take a cup of coffee as a reward ;)!"
read stop_var
