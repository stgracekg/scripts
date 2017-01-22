#!/bin/bash
# This file was created on Fri 20 Jan 2017 11:11:00 PM IST
# Last edit on Mon 23 Jan 2017 12:47:05 AM IST
# Script for DNZ zones updates

restore="\e[0m"         # Colors
warn="\e[00;31m"        # red
success="\e[01;32m"     # light green
white="\e[01;37m"
yellow="\e[00;33m"
lyellow="\e[01;33m"
lmagenta="\e[01;35m"

key="/var/named/rndc.key"
local_ns=10.0.0.1
remote_ns=37.139.15.19
localzone=locco.org
remotezone=kirgizia.online
reversezone=0.0.10.in-addr.arpa
prefix=10.0.0
maxrange=254

update () {
  cat <<EOF | nsupdate -k "$key"
  server $server
  zone $zone
  update delete $zone. A
  update add $zone. 600 A $ipaddr
  update delete $name.$zone. A
  update add $name.$zone. 600 A $ipaddr
  send
EOF
}
update_ptr () {
  cat <<EOF | nsupdate -k "$key"
  server $server
  zone $reversezone.
  update delete $reversezone. PTR
  update add $reversezone. 600 PTR $localzone.
  update delete $suffix.$reversezone. PTR
  update add $suffix.$reversezone. 600 PTR $name.$localzone.
  send
EOF
}
delete () {
  cat <<EOF | nsupdate -k "$key"
  server $server
  zone $zone
  update delete $name.$zone. A
  send
EOF
}
delete_ptr () {
  cat <<EOF | nsupdate -k "$key"
  server $server
  zone $reversezone.
  update delete $suffix.$reversezone. PTR
  update delete $suffix.$reversezone. 600 PTR $name.$localzone.
  send
EOF
}
while true
do
echo -ne "$white"
#printf "%60s\n" "----------------------------" 
printf "${lyellow}%50s${restore}\n" "DNS update"
printf "${white}%60s\n" "----------------------------"
printf "%25s %53s \n" "[1] Add host to $localzone"  "[3] Delete host in $localzone"
printf "%25s %50s \n" "[2] Add host to $remotezone" "[4] Delete $remotezone host"
printf "%40s\n" "[q] Exit"
echo
echo -e "Enter your selection:\c "
echo -e "$restore"
read dnsserver
  case $dnsserver in
    1)
      server="$local_ns"
      zone="$localzone"
      echo -e "Enter DNS hostname in $localzone: \c"
      read name
      echo -e "Enter IP address suffix:\c"
      read suffix
      if ((suffix >= maxrange))
      then
        echo -e "$warn Update $white $localzone ${warn}failed. Out of range value.$restore \n"
        echo -e "Enter IP address suffix:\c"
        read suffix
        if ((suffix < maxrange))
        then  
          ipaddr="$prefix.$suffix"
          echo "$ipaddr"
        fi
      else 
        ipaddr="$prefix.$suffix"
        echo -e "${lmagenta}New IP address ${white}$ipaddr${restore}"
        echo -e "${lmagenta}New hostname is ${white}$name.$zone${restore}\n"
        update
      fi
        if [ $? != 0 ]
        then 
        echo -e "$warn Update $white $localzone $success failed...$restore \n"
        else echo -e "$success Update $white $localzone $success successful!$restore\n"
####### Reverse block starts.
          echo -e "$white Update reverse? (Y|n)$restore: \c"
          read answer
          echo
          case $answer in
            y|Y|*) echo -e " Updating PTR record for ${white}$name.$zone $restore\n" 
              update_ptr
              if [ $? != 0 ]
                then echo -e "$warn Update failed...$restore\n"
                else echo -e "$success Updated ${white}$reversezone. $restore\n"
              fi
                ;;
            n) echo -e "$white Not updating reverse$restore\n" ;;
          esac
######## Reverse block ends.
      fi  
      ;;
    2) 
      extip=$(/usr/bin/curl -s -4 my.ip.fi)
      server="$remote"
      zone="$remotezone"
      echo -e "Remote ip address is $extip\n"
      echo -e "Enter DNS hostname in $zone: \c"
      ipaddr="$extip"
      read name
      update
      if [ $? != 0 ]
      then 
        echo -e "$warn Update failed...$restore \n"
      else echo -e "$success Update successful!$restore\n"
      fi  
      ;;
    3)
      server="$local_ns"
      zone="$localzone"
      echo -e "Deleting host in $zone"
      echo -e "Enter DNS hostname in $localzone: \c"
      read name
      echo "Enter IP address suffix: "
      read suffix
      delete
      if [ $? != 0 ]
      then 
        echo -e "$warn Update failed...$restore \n"
      else echo -e "$success Update successful!$restore\n"
####### Reverse block starts
        echo -e "$white Update reverse? (Y|n)$restore: \c"
        read answer
        case $answer in
          y|Y|*) echo -e "Deleting PTR record for $white $name.$localzone $restore\n" 
            delete_ptr
            if [ $? != 0 ]
            then echo -e "$warn Update failed...$restore\n"
            else echo -e "$success Deleted $white $prefix.$suffix from $reversezone $success successful!$restore\n"
            fi
            ;;
          n) echo -e "Not updating reverse" ;;
        esac
######## Reverse block ends    
      fi  
      ;;
    4) 
      extip=$(/usr/bin/curl -s -4 my.ip.fi)
      server="$remote"
      zone="$remotezone"
      echo -e "Remote ip address is $extip\n"
      echo -e "Enter DNS hostname in $zone: \c"
      ipaddr="$extip"
      read name
      delete
      if [ $? != 0 ]
      then 
        echo -e "$warn Update failed...$restore\n"
      else echo -e "$success Update successful!$restore\n"
      fi  
      ;;
     q) exit 0
      ;; 
  esac 
done
