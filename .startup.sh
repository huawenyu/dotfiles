#!/bin/bash
#
# Execute that script when boots up, please use 'crontab -e' and adding this line:
# @reboot /home/wilson/.startup.sh

#setxkbmap -option caps:none
#xmodmap .Xmodmap
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
