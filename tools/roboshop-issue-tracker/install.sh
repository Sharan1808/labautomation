#!/bin/bash

echo -e "This script runs only in FRONTEND, Hence if you are sure that you are \nrunning under frontend server then proceed.."
read -p 'Proceed [Y|n]: ' action
ACTION=$(echo $action| cut -c -1 | tr [a-z] [A-Z])
if [ "$ACTION" == "Y" ]; then
  if [ ! -f /etc/nginx/default.d/roboshop.conf ]; then
    echo -e "\e[1;33mUnable to find the Frontend Nginx Setup, Exiting.."
    exit 1
  fi
else
  exit
fi

DLIM() {
  echo -e "---------------------------------------------------------------------------------------------------------"
}

## Cases

for component in Catalogue Cart User Shipping Payment; do
  DLIM
  cat /etc/nginx/default.d/roboshop.conf | grep -i "$component" | grep localhost &>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "Checking Configuration for $component - \e[1;31mNOT FOUND\e[0m"
    continue
  fi
  echo -e "Checking Configuration for $component - \e[1;32mFOUND\e[0m"
  DLIM
  echo -e "Grabbing IP Address of $component"
  IP=$(cat /etc/nginx/default.d/roboshop.conf  | grep -i $component  | awk -F : '{print $(NF-1)}' | sed -e 's|//||')
  echo -e "Found , $component IP, IP = $IP"
  DLIM
  echo -e "Connecting to $component and checking the status"
  nc -w 5  -z $IP 22 &>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "Connection \e[1;32mSUCCESS\e[0m"
  else
    echo -e "Connection \e[1;31mFAILURE\e[0m"
    echo exiting ....
    exit 1
  fi
done
