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
  x=$(($col - ${#header_msg} / 2));
  BANNER="${BANNER}$1";
  return;
}

MENU_HEADING="Menu Menu of Xrobot";

# Main Body loop
while true
do
  # Outer loop variables
  col=`tput cols`;
  row=`tput lines`;
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
      # If right-hand side column
      elif (( $x == $col - 1 ))
      then
        BANNER="${BANNER}\n";
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
      # echo $x;
      # echo $col;
      # echo $y;
      x=$((x=x+1)); # Increment inner loop
    done

  y=$((y=y+1)); # Increment outer loop
  done 

echo -e "$BANNER";
sleep 1;
clear;
sleep 1;
done

