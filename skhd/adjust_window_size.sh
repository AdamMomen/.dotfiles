#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 {height|width} {increase|decrease}"
    exit 1
fi

# Assign arguments to variables
dimension=$1
action=$2

# Define the amount to change the size
delta=20  # Change this value as needed

# Get the ID of the currently focused window
current_window=$(yabai -m query --windows --window | jq -r '.id')

# Function to adjust window size
adjust_size() {
    direction=$1
    change=$2
    if [ "$dimension" == "height" ]; then
        axis='y'
    else
        axis='x'
    fi

    if [ "$action" == "increase" ]; then
        if [ "$dimension" == "height" ]; then
            yabai -m window $current_window --resize $direction:0:$change
        else
            yabai -m window $current_window --resize $direction:$change:0
        fi
    elif [ "$action" == "decrease" ]; then
        change=-$change
        if [ "$dimension" == "height" ]; then
            yabai -m window $current_window --resize $direction:0:$change
        else
            yabai -m window $current_window --resize $direction:$change:0
        fi
    fi
}

# Adjust size based on the direction
case $dimension in
    height)
        if [ "$action" == "increase" ]; then
            adjust_size "bottom" $delta
        elif [ "$action" == "decrease" ]; then
            adjust_size "top" $delta
        fi
        ;;
    width)
        if [ "$action" == "increase" ]; then
            adjust_size "right" $delta
        elif [ "$action" == "decrease" ]; then
            adjust_size "left" $delta
        fi
        ;;
    *)
        echo "Invalid dimension. Use 'height' or 'width'."
        exit 2
        ;;
esac

