#!/usr/bin/bash -l
# run as cronjoba
ac=$(acpi -a | sed -n 's/.* \([^-]*\)-line/\1/p')
if [ "$ac" = "off" ]; then
	lvl=$(acpi -b | sed -n 's/.* \([0-9]\+\)\%.*/\1/p')
	[[ "$lvl" -lt 12 ]] && notify-send -u critical -t 2500 "Low Battery: Only $lvl percent capacity remaining. Connect to AC or system will suspend to RAM"
	[[ "$lvl" -lt 7 ]] && systemctl suspend
fi
bash $(dirname $0)/batlog.sh
