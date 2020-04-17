#!/bin/bash

if [[ "$SNAP_ARCH" == "amd64" ]]; then
  ARCH="x86_64-linux-gnu"
elif [[ "$SNAP_ARCH" == "armhf" ]]; then
  ARCH="arm-linux-gnueabihf"
elif [[ "$SNAP_ARCH" == "arm64" ]]; then
  ARCH="aarch64-linux-gnu"
else
  ARCH="$SNAP_ARCH-linux-gnu"
fi

# Pulseaudio export
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SNAP/usr/lib/$ARCH/pulseaudio
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SNAP/lib/$ARCH

#CURRENT_SWITCHER_FILE=$SNAP_USER_DATA/current_switcher.conf
SINKS_COUNT=`pactl list sinks short | awk '{print $1}' | wc -l`
SINKS=(`pactl list sinks short | awk '{print $1}'`)
RUNNING_SINK=(`pactl list sinks short | grep RUNNING | awk '{print $1}'`)
INPUTS=(`pactl list sink-inputs short | awk '{print $1}'`) 

CURRENT_SWITCHER=0
#if [ -f "$CURRENT_SWITCHER_FILE" ] ; then 
#    read CURRENT_SWITCHER < $CURRENT_SWITCHER_FILE
#else
#    echo "0" > $CURRENT_SWITCHER_FILE
#fi
    
if [[ $CURRENT_SWITCHER == 0 ]]; then
    for i in ${!SINKS[*]}; do
	if [[ ${SINKS[$i]} == $RUNNING_SINK ]]; then
		SINK_INDEX=$i
	fi
    done

    if [[ ${#SINKS[@]} -ne 0 ]] && [[ ${SINKS[-1]} -eq $RUNNING_SINK ]]; then	
	pactl set-default-sink ${SINKS[0]}
	for i in ${INPUTS[*]}; do 
		pactl move-sink-input $i ${SINKS[0]}
	done
	notify-send "Switching to `pactl list sinks short | grep RUNNING | awk  '{print $2}' | awk -F "." '{print $NF}'`"

    else	
	NEW_INDEX=$((SINK_INDEX+1))
	pactl set-default-sink ${SINKS[$NEW_INDEX]}
	for i in ${INPUTS[*]}; do 
		pactl move-sink-input $i ${SINKS[$NEW_INDEX]}
	done
	notify-send "Switching to `pactl list sinks short | grep RUNNING | awk  '{print $2}' | awk -F "." '{print $NF}'`"
    fi

fi

 

