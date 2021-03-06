#!/bin/sh -e
#  _____ _        _             _
# /  ___| |      | |           | |
# \ `--.| |_ __ _| |_ _   _ ___| |__   __ _ _ __
#  `--. | __/ _` | __| | | / __| '_ \ / _` | '__|
# /\__/ | || (_| | |_| |_| \__ | |_) | (_| | |
# \____/ \__\__,_|\__|\__,_|___|_.__/ \__,_|_|
#
# MODDWM STATUSBAR - Modular Dynamic Window Manager Statusbar Gruvbox Flavour.
# ----------------------------------------------------------------------------
#  "THE BEER-WARE LICENSE" (Revision 42):
#  Plasmoduck <plasmoduck@gmail.com> wrote this file.  As long as you retain this notice you
#  can do whatever you want with this stuff. If we meet some day, and you think
#  this stuff is worth it, you can buy me a beer in return - Plasmoduck.
# ---------------------------------------------------------------------------- 

cpu (){
       vmstat | awk 'NR==3 {print $(NF-2)}'     # See man vmstat(1)
}

cpu_temp (){
       _temp=$(sysctl dev.cpu.0.temperature | sed -e 's|.*: \([0-9]*\).*|\1|')  # See man sysctl(1)
        if test "$_temp" -ge 55; then
                _tempicon=
        elif test "$_temp" -ge 1; then
                _tempicon=
        fi
        printf ^c#E78A4E^%s^c#D5C4A1^%s "$_tempicon" "$_temp"°
}

memory (){
	free | awk '(NR == 18) {print $6}'      # free is a perl script to show free ram on FreeBSD.
}

drive (){
	df -h | grep '/$' | awk '{print $5}'
}

volume (){
	_vol=$(mixer -s vol | grep -Eo '[0-9]+$')       # FreeBSD uses mixer(1) for audio.
        if test "$_vol" -ge 50; then
                _volicon=
        elif test "$_vol" -ge 20; then
                _volicon=
        elif test "$_vol" -ge 2; then
                _volicon=
        elif test "$_vol" -eq 0; then
                _volicon=
        fi
        printf ^c#83A598^%s^c#D5C4A1^%s%% "$_volicon" "$_vol"
}

battery(){
	_acstat=$(apm -a)	# A/C status, 0 means disconnected, 1 means connected (check apm(1) -a)
	_battperc=$(apm -l)	# the estimated battery life time in percent (check apm(1) -l)
	if test "$_acstat" -eq 1; then
		_batticon=
	else
		if test "$_battperc" -ge 60; then
			_batticon=
		elif test "$_battperc" -ge 40; then
			_batticon=
		elif test "$_battperc" -ge 1; then
			_batticon=
		fi
	fi
	printf ^c#8EC07C^%s^c#D5C4A1^%s%% "$_batticon" "$_battperc"
}

print_date (){
	date "+%H:%M"
}

wifi (){
#       ifconfig wlan0 | grep ssid | cut -w -f 3        # Print wireless SSID name.
        ifconfig wlan0 | grep txpower | cut -w -f 3     # Print wireless SSID signal strength.
}

while true
do
    dwm -s "^b#322F2E^^c#FB4934^^c#D5C4A1^$(cpu)% $(cpu_temp) ^c#FABD2F^^c#D5C4A1^$(memory) ^c#B8BB26^^c#D5C4A1^$(drive) $(volume) $(battery) ^c#D3869B^^c#D5C4A1^$(print_date)"
	sleep 5
done
