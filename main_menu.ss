#!/bin/bash

# Main Body loop
while true
do
  # Outer loop variables
  col=`tput cols`;
  row=`tput lines`;
  BANNER="";
  BOTTOMROW=6;
  y=0;

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
      elif (( $y == 3 )) && (( $x == 4 ))
      then
        BANNER="${BANNER} MENU TITLE HERE";
      elif (( $y > $BOTTOMROW + 2 ))
      then
        break 2; # Exit both outer and inner loops
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
