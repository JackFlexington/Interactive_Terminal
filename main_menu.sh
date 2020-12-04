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
USER_PROMPT_TIME=0.117;
OUTPUT_WAIT_TIME=1;
SHELL_OUT_TIMER=5;

# Standard Color Formatting
TEXT_RED='\033[0;31m'; # RED
TEXT_GREEN='\033[0;32m'; # GREEN
TEXT_YELLOW='\033[1;33m'; # YELLOW
TEXT_BLUE='\033[0;34m'; # BLUE
TEXT_LIGHT_BLUE='\033[1;34m'; # LIGHT BLUE
TEXT_LIGHT_PURPLE='\033[1;35m'; # LIGHT PURPLE
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

# Load Main Menu Functions
source func.sh;

# Main Body loop
while true
do
  refresh_screen;

clear; # Refresh screen
echo -e "$BANNER";
echo -e "$MENU_MSG";
display_inspection_tools;

# User Input Method #3
while [ "${USER_INPUT}" == "" ] 
do
  tput cup 11 0 && tput ed # https://unix.stackexchange.com/questions/297502/clear-half-of-the-screen-from-the-command-line
  echo -e "${TEXT_LIGHT_BLUE}system awaiting user input...${TEXT_NC}";
  read -t${USER_PROMPT_TIME} -n1 -p "CLI:>>>" detect_input; # 3-sec timer ; accept single character ; user prompt message
  # sleep 0.01;
  if [ "${detect_input^}" != "" ] # To uppercase first character in $USER_INPUT
  then
    # Move cursor, clear to end of screen
    tput cup 11 0 && tput ed # https://unix.stackexchange.com/questions/297502/clear-half-of-the-screen-from-the-command-line
    if [ ${detect_input} == '$' ]
    then
      echo -e "${TEXT_LIGHT_PURPLE}(SHELL OUT)${TEXT_NC}";
      echo -e "${TEXT_LIGHT_BLUE}CWD=`pwd`${TEXT_NC}";
      read -t${SHELL_OUT_TIMER} -p "CLI>>>" USER_INPUT;
      echo -e "${TEXT_YELLOW}Command entered >>>${USER_INPUT}${TEXT_NC}";
      ${USER_INPUT};
      sleep ${OUTPUT_WAIT_TIME};
      # Clear read buffer
      USER_INPUT="";
      # read -t${USER_PROMPT_TIME} -n 10000 discard;
      continue; # Skip to next cycle
    fi
    echo -e "${TEXT_YELLOW}User typing...${TEXT_NC}";
    # sleep 2;
    read -t${USER_PROMPT_TIME} -p "CLI:>>>${detect_input}" USER_INPUT;
    # sleep 0.01;
    echo "(YOU KEYED IN) ${detect_input}${USER_INPUT}";
    sleep ${OUTPUT_WAIT_TIME};
    USER_INPUT="${detect_input}${USER_INPUT}";
    # sleep 2;
    # Do something with $USER_INPUT here
    USER_INPUT="";
  else
    refresh_screen;
    clear; # Refresh screen
    echo -e "$BANNER";
    echo -e "$MENU_MSG";
    display_inspection_tools; # Update Inspection tools
  fi
done  

sleep 0.1; # Wanted to give it some sort of expected cycle count
done