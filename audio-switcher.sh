#!/bin/bash
SINKS_COUNT=`pactl list sinks short | awk '{print $1}' | wc -l`
SINKS=(`pactl list sinks short | awk '{print $1}'`)
RUNNING_SINK=(`pactl list sinks short | grep RUNNING | awk '{print $1}'`)
INPUTS=(`pactl list sink-inputs short | awk '{print $1}'`) 

for i in ${!SINKS[*]}; do
	if ((${SINKS[$i]} == $RUNNING_SINK)); then
		SINK_INDEX=$i
	fi
done

if ((${SINKS[-1]} ==  $RUNNING_SINK)); then	
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
	


 

