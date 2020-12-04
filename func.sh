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
  count_x=$((count_x=count_x+${#header_msg}-1));
  BANNER="${BANNER}$1";
  return;
}

# Inspection Tools Method #3
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

# Refresh screen
refresh_screen() {
  # Outer loop variables
  # echo $STATIC_SCREEN;
  STATIC_SCREEN=$((STATIC_SCREEN=STATIC_SCREEN+1));
  coord_x=`tput cols`;
  coord_y=`tput lines`;
#   if (( $LAST_KNOWN_X == $coord_x )) && (( $LAST_KNOWN_Y == $coord_y )) && (( $STATIC_SCREEN % 500 > 0 ))
#   then
#     continue;
#   fi
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
}