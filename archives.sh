  # Inspection Tools Method #1
  # # Show TOP records
  # elif (( $count_y == 1 )) && (( $count_x == 2 ))
  # then
  #   display_load_balance "LOAD";
  # # Show DISK USAGE records
  # elif (( $count_y == 1 )) && (( $count_x == 12 ))
  # then
  #   display_disk_usage "DISK";
  # # Show DISK USAGE records
  # elif (( $count_y == 1 )) && (( $count_x == 22 ))
  # then
  #   display_crond_status "CRON";
  # If right-hand side column
  # elif (( $count_y == 1 ))
  # then
  #   # INSPECTION_TOOLS="$INSPECTION_TOOLS display_crond_status";
  #   # echo -e "$INSPECTION_TOOLS";
  #   count_y=$((count_y=count_y+1))

  
# Inspection Tools Method #2
# display_load_balance() {
#   header_msg=$1;
#   load_values=`cat /proc/loadavg | cut -d' ' -f1`;
#   BANNER="${BANNER}$1:$load_values";
#   count_x=$((count_x=count_x+${#header_msg}+${#load_values}));
#   return;
# }
#
# display_disk_usage() {
#   disk_values=`df / --output=pcent | tail -n1`;
#   header_msg=$1;
#   BANNER="${BANNER}$1:$disk_values";
#   count_x=$((count_x=count_x+${#header_msg}+${#disk_values}));
#   return;
# }
#
# display_crond_status() {
#   crond_values=`pgrep crond`;
#   header_msg=$1;
#   # echo "$crond_values";
#   if [ $crond_values != "" ]
#   then
#     BANNER="${BANNER}$1:T";
#   else
#     BANNER="${BANNER}$1:F";
#   fi
#   count_x=$((count_x=count_x+${#header_msg}+1));
# }

# User Input Method #1
# echo -e "(CLI ${TEXT_RED}deactivated${TEXT_NC})"
# read -t3 -n1 -p "<enter \"T\" to enable>" USER_INPUT; # 3-sec timer ; accept single character ; user prompt message
# if [ "${^}" == "T" ] # To uppercase first character in $USER_INPUT
# then
#   # Move cursor, clear to end of screen
#   tput cup 11 0 && tput ed # https://unix.stackexchange.com/questions/297502/clear-half-of-the-screen-from-the-command-line
#   echo -e "(CLI ${TEXT_GREEN}activated${TEXT_NC})";
#   read -t5 -p "Enter command here:>" USER_INPUT;
# fi

# User Input Method #2
# if [ "$INPUT_BUFFER" == "" ]
# then
#   echo -e "$TEXT_GRAY<Nothing in buffer>$TEXT_NC";
# else
#   echo -e "$INPUT_BUFFER";
# fi
# # echo $INPUT_BUFFER;
# # echo $USER_INPUT;
# # sleep 1;
# read -n1 -p "user input -->" USER_INPUT;
# if [ "${USER_INPUT^}" != "" ] # To uppercase first character in $USER_INPUT
# then
#   INPUT_BUFFER="${INPUT_BUFFER}${USER_INPUT}";
# fi
# USER_INPUT=""; # Reset input buffer
