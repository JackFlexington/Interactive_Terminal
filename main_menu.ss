#!/bin/bash

# Global Variables
TITLE_OPTS=("N" ".) Copy files newer than" "X" ".) Exit program");
MENU_HEADING="(Interactive monitoring & control window)";
LAST_KNOWN_X=0;
LAST_KNOWN_Y=0;
STATIC_SCREEN=100;
# INPUT_BUFFER=""; # User Input Method #2
INSPECTION_TOOLS="X "; 
USER_INPUT="";

# Standard Color Formatting
TEXT_RED='\033[0;31m'; # RED
TEXT_GREEN='\033[0;32m'; # GREEN
TEXT_YELLOW='\033[1;33m'; # YELLOW
TEXT_BLUE='\033[0;34m'; # BLUE
TEXT_LIGHT_BLUE='\033[1;34m'; # LIGHT BLUE
TEXT_GRAY='\033[0;37m'; # GRAY
TEXT_NC='\033[0m'; # No color

# Components
banner() {
  # Top & Bottom menu rows
  if (( $count_y == 0 )) || (( $count_y == $BOTTOMROW ))
  then
    BANNER="${BANNER}X";
  # Left-hand column & Above bottom row
  elif (( $count_x == 0 )) && (( $count_y < $BOTTOMROW ))
  then
    BANNER="${BANNER}X";
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
  elif (( $count_x == $coord_x - 1 )) && (( $count_y < $BOTTOMROW ))
  then
    BANNER="${BANNER}X\n";
  elif (( $count_y == 3 )) && (( $count_x == $HEAD_START ))
  then
    display_menu_heading "$MENU_HEADING";
  else
    BANNER="${BANNER} ";
  fi
  return;
}

user_menu() {
  case $1 in
  "title")
    len=$((${#TITLE_OPTS[@]}));
    title_loop=0;
    MENU_MSG="";
    largest_string=0;
    for curr_str in "${TITLE_OPTS[@]}"
    do
      if ((${#curr_str} > $largest_string))
      then
        largest_string=${#curr_str};
      fi
    done
    pad_left="|";
    pad_left_end=$((($coord_x - $largest_string) / 2));
    for (( i=1 ; i<=$pad_left_end ; i ++ ))
    do 
      pad_left="$pad_left "; 
    done
    while (($title_loop < $len))
    do
      MENU_MSG="$MENU_MSG$pad_left";
      MENU_MSG="$MENU_MSG${TITLE_OPTS[$title_loop]}";
      MENU_MSG="$MENU_MSG${TITLE_OPTS[$title_loop+1]}\n";
      title_loop=$((title_loop=title_loop+2));
    done
    ;;
  *)
    # echo "in default";
    # sleep .5
    ;;
  esac
  return;
}

# Script Functions
find_header_coords() {
  header_msg=$1;
  HEAD_START=$(( ($coord_x - ${#header_msg}) / 2 ))
  # echo "RESULT= $result";
  return $result;
}

display_menu_heading() {
  header_msg=$1;
  result=$(( ($coord_x - ${#header_msg}) / 2 ))
  # count_x=$(($coord_x - ${#header_msg}));
  count_x=$((count_x=count_x+${#header_msg}-1));
  BANNER="${BANNER}$1";
  return;
}

# Inspection Tools Method #1
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

# Inspection Tools Method#2
inspection_top() {
  INSPECTION_TOOLS="${INSPECTION_TOOLS} TOP:"`cat /proc/loadavg | cut -d' ' -f1`;
}

inspection_disk() {
  INSPECTION_TOOLS="${INSPECTION_TOOLS} DISK:"`df / --output=pcent | tail -n1`;
}

inspection_cron() {
  crond_values=`pgrep crond`;
  if [ $crond_values != "" ]
  then
    INSPECTION_TOOLS="${INSPECTION_TOOLS} CRON ${TEXT_GREEN}T${TEXT_NC}";
  else
    INSPECTION_TOOLS="${INSPECTION_TOOLS} CRON ${TEXT_GREEN}F${TEXT_NC}";
  fi
}

# User Input Method #3
display_inspection_tools() {
  tput sc; # Save cursor position @ user input prompt
  tput cup 1 0; # Move cursor to inline inspection tools
  INSPECTION_TOOLS="X";
  inspection_top;
  inspection_disk;
  inspection_cron;
  echo -e "$INSPECTION_TOOLS"; # Overwrite line under cursor
  tput rc; # Return to save cursor location
}

# Main Body loop
while true
do
  # Outer loop variables
  # echo $STATIC_SCREEN;
  STATIC_SCREEN=$((STATIC_SCREEN=STATIC_SCREEN+1));
  coord_x=`tput cols`;
  coord_y=`tput lines`;
  if (( $LAST_KNOWN_X == $coord_x )) && (( $LAST_KNOWN_Y == $coord_y )) && (( $STATIC_SCREEN % 500 > 0 ))
  then
    continue;
  fi
  STATIC_SCREEN=0;
  LAST_KNOWN_X=$coord_x;
  LAST_KNOWN_Y=$coord_y;
  BANNER="";
  BOTTOMROW=6;
  count_y=0;
  find_header_coords "$MENU_HEADING";

  # For each column position
  while (($count_y < $coord_y))
  do
    # Inner loop variables
    count_x=0;
    
    # For each row position
    while (($count_x < $coord_x))
    do      
      # Load which component
      
      if (( $count_y > $BOTTOMROW + 1 ))  
      then
        user_menu "title"; # Invoke user menu component
        break 2;
      else
        banner; # Invoke banner menu
      fi

      # if (( $count_y > $BOTTOMROW + 1 ))  
      # then
      #   break 2; # Exit both outer and inner loops
      # fi
      count_x=$((count_x=count_x+1)); # Increment inner loop
    done

  count_y=$((count_y=count_y+1)); # Increment outer loop
  done 

clear; # Refresh screen
echo -e "$BANNER";
echo -e "$MENU_MSG";
display_inspection_tools;

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

# User Input Method #3
while [ "${USER_INPUT}" == "" ] 
do
  tput cup 11 0 && tput ed # https://unix.stackexchange.com/questions/297502/clear-half-of-the-screen-from-the-command-line
  echo -e "${TEXT_LIGHT_BLUE}system awaiting user input...${TEXT_NC}";
  read -t3 -n1 -p "CLI:>>>" detect_input; # 3-sec timer ; accept single character ; user prompt message
  if [ "${detect_input^}" != "" ] # To uppercase first character in $USER_INPUT
  then
    # Move cursor, clear to end of screen
    tput cup 11 0 && tput ed # https://unix.stackexchange.com/questions/297502/clear-half-of-the-screen-from-the-command-line
    echo -e "${TEXT_YELLOW}User typing...${TEXT_NC}";
    # sleep 2;
    read -t5 -p "CLI:>>>${detect_input}" USER_INPUT;
    echo "(YOU KEYED IN) ${detect_input}${USER_INPUT}";
    USER_INPUT="${detect_input}${USER_INPUT}";
    sleep 2;
    # Do something with $USER_INPUT here
    USER_INPUT="";
  else
    display_inspection_tools; # Update Inspection tools
  fi
done

sleep 0.1; # Wanted to give it some sort of expected cycle count
done
