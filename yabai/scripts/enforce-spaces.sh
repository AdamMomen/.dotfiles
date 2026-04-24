#!/bin/bash
# Yabai Space Enforcement Script
# Called by signals to move windows to their correct spaces

# Space 1 - Browsers
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Brave" and .space!=1) | .id' | xargs -I {} yabai -m window {} --space 1 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Dai" and .space!=1) | .id' | xargs -I {} yabai -m window {} --space 1 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Safari" and .space!=1) | .id' | xargs -I {} yabai -m window {} --space 1 2>/dev/null

# Space 2 - Productivity
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Notion" and .space!=2) | .id' | xargs -I {} yabai -m window {} --space 2 2>/dev/null

# Space 3 - Terminal
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="iTerm2" and .space!=3) | .id' | xargs -I {} yabai -m window {} --space 3 2>/dev/null

# Space 4 - Development
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Cursor" and .space!=4) | .id' | xargs -I {} yabai -m window {} --space 4 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Antigravity" and .space!=4) | .id' | xargs -I {} yabai -m window {} --space 4 2>/dev/null

# Space 5 - System Tools
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Postico 2" and .space!=5) | .id' | xargs -I {} yabai -m window {} --space 5 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="NordVPN" and .space!=5) | .id' | xargs -I {} yabai -m window {} --space 5 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="System Settings" and .space!=5) | .id' | xargs -I {} yabai -m window {} --space 5 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="App Store" and .space!=5) | .id' | xargs -I {} yabai -m window {} --space 5 2>/dev/null

# Space 6 - Work
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Slack" and .space!=6) | .id' | xargs -I {} yabai -m window {} --space 6 2>/dev/null

# Space 7 - Messaging
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Telegram" and .space!=7) | .id' | xargs -I {} yabai -m window {} --space 7 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Discord" and .space!=7) | .id' | xargs -I {} yabai -m window {} --space 7 2>/dev/null

# Space 8 - Media
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Music" and .space!=8) | .id' | xargs -I {} yabai -m window {} --space 8 2>/dev/null

# Space 9 - AI
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Claude" and .space!=9) | .id' | xargs -I {} yabai -m window {} --space 9 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="ChatGPT" and .space!=9) | .id' | xargs -I {} yabai -m window {} --space 9 2>/dev/null
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Codex" and .space!=9) | .id' | xargs -I {} yabai -m window {} --space 9 2>/dev/null

# Space 10 - Meetings
yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.app=="Zoom" and .space!=10) | .id' | xargs -I {} yabai -m window {} --space 10 2>/dev/null
