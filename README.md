# WeeklyUpdateMeetingScript

Contains: 
* Latex template file for a (weekly) update meeting notes. 
* create_new_week.sh script, when ran it asks for a new year-week and the script will create a new directory containing a new latex file containing all the todo's from the last update meeting that were not completed (striked_through). 

In order for script to work you **MUST** use the the \strike[color]{text to be striked thourgh} command to mark todos as done.

# How to get stared
* Run the create_new_week.sh script and input the current year-week number. 
* Add the newly created latex file in the new year-week directory. 
* Have an update meeting
* Run the create_new_week.sh again with the new year-week number and repeat!