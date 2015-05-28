#!/usr/bin/bash
exar=('full capacity\s*:\s*\([0-9]\+\)' 'remaining capacity\s*:\s*\([0-9]\+\)' 'present rate\s*:\s*\([0-9]\+\)')
csv="$(date +%s)"
while read line; do
	for i in $(seq ${#exar[@]}); do
		[[ -z "$val" ]] && val=$(echo "$line" | sed -n "s/^.*${exar[$i-1]}.*\$/\1/Ip" )
	done
	[[ -n "$val" ]] && csv="$csv, $val" && val=""
done < <(acpitool --battery)
echo $csv >> "$(dirname $0)/bat.log"
