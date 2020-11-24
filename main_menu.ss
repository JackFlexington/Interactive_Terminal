#!/bin/bash
# Script Functions

find_header_coords() {
  header_msg=$1;
  HEAD_START=$(( ($col - ${#header_msg}) / 2 ))
  # echo "RESULT= $result";
  return $result;
}

display_menu_heading() {
  header_msg=$1;
  result=$(( ($col - ${#header_msg}) / 2 ))
  # x=$(($col - ${#header_msg}));
  x=$((x=x+${#header_msg}-1));
  BANNER="${BANNER}$1";
  return;
}

display_load_balance() {
  header_msg=$1;
  load_values=`cat /proc/loadavg | cut -d' ' -f1`;
  BANNER="${BANNER}$1:$load_values";
  x=$((x=x+${#header_msg}+${#load_values}));
  return;
}

display_disk_usage() {
  disk_values=`df / --output=pcent | tail -n1`;
  header_msg=$1;
  BANNER="${BANNER}$1:$disk_values";
  x=$((x=x+${#header_msg}+${#disk_values}));
  return;
}

display_crond_status() {
  crond_values=`pgrep crond`;
  header_msg=$1;
  echo "$crond_values";
  if [ $crond_values != "" ]
  then
    BANNER="${BANNER}$1:T";
  else
    BANNER="${BANNER}$1:F";
  fi
  x=$((x=x+${#header_msg}+1));
}

MENU_HEADING="Welcome to Dashboards";
LAST_KNOWN_X=0;
LAST_KNOWN_Y=0;
STATIC_SCREEN=100;

# Main Body loop
while true
do
  # Outer loop variables
  # echo $STATIC_SCREEN;
  STATIC_SCREEN=$((STATIC_SCREEN=STATIC_SCREEN+1));
  col=`tput cols`;
  row=`tput lines`;
  if (( $LAST_KNOWN_X == $col )) && (( $LAST_KNOWN_Y == $row )) && (( $STATIC_SCREEN % 500 > 0 ))
  then
    continue;
  fi
  STATIC_SCREEN=0;
  LAST_KNOWN_X=$col;
  LAST_KNOWN_Y=$row;
  BANNER="";
  BOTTOMROW=6;
  y=0;
  find_header_coords "$MENU_HEADING";

  # For each column position
  while (($y < $row))
  do
    # Inner loop variables
    x=0;
    
    # For each row position
    while (($x < $col))
    do
      # Top & Bottom menu rows
      if (( $y == 0 )) || (( $y == $BOTTOMROW ))
      then
        BANNER="${BANNER}X";
      # Left-hand column & Above bottom row
      elif (( $x == 0 )) && (( $y < $BOTTOMROW ))
      then
        BANNER="${BANNER}X";
      # Show TOP records
      elif (( $y == 1 )) && (( $x == 2 ))
      then
        display_load_balance "LOAD";
      # Show DISK USAGE records
      elif (( $y == 1 )) && (( $x == 12 ))
      then
        display_disk_usage "DISK";
      # Show DISK USAGE records
      elif (( $y == 1 )) && (( $x == 22 ))
      then
        display_crond_status "CRON";
      # If right-hand side column
      elif (( $x == $col - 1 )) && (( $y < $BOTTOMROW ))
      then
        BANNER="${BANNER}X\n";
      elif (( $y == 3 )) && (( $x == $HEAD_START ))
      then
        display_menu_heading "$MENU_HEADING";
      elif (( $y > $BOTTOMROW + 1 ))
      then
        break 2; # Exit both outer and inner loops
      else
        BANNER="${BANNER} ";
      # elif (( $x < $col ))
      # then
      #   BANNER="${BANNER} ";
      # else
      #   BANNER="${BANNER} ";
      fi
      # sleep 0.01;
      # clear;
      # echo -e "$BANNER";
      # echo $x;
      # echo $col;
      # echo $y;
      x=$((x=x+1)); # Increment inner loop
    done

  y=$((y=y+1)); # Increment outer loop
  done 
clear;
echo -e "$BANNER";
sleep 0.1; # Wanted to give it some sort of expected cycle count
done

