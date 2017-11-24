#!/usr/bin/env bash

version(){
printf "Logitech BASH control v1.03\n"
}

ledoff(){
uvcdynctrl -s 'LED1 Mode' -- 0
printf "LED turned off!\n"
}

ledon(){
uvcdynctrl -s 'LED1 Mode' -- 1
printf "LED turned on!\n"
}

ledblink(){
uvcdynctrl -s 'LED1 Mode' -- 2
printf "LED is blinking!\n"
}

panleft(){
uvcdynctrl -s 'Pan (relative)' -- 250
printf "Camera panned left by 250 steps!\n"
}

panright(){
uvcdynctrl -s 'Pan (relative)' -- -250
printf "Camera panned right by -250 steps!\n"
}

panreset(){
uvcdynctrl -s 'Pan Reset' -- 0
printf "Camera pan reset\n"
}

tiltup(){
uvcdynctrl -s 'Tilt (relative)' -- -250
printf "Camera tilted up by -250 steps!\n"
}

tiltdown(){
uvcdynctrl -s 'Tilt (relative)' -- 250
printf "Camera tilted down by 250 steps!\n"
}

tiltreset(){
uvcdynctrl -s 'Tilt Reset' -- 0
printf "Camera tilt reset\n"
}

keycontrol(){
printf "Control the camera with the arrow keys, reset with \'r\', quit with \'q\'\n"

while read -rsn1 ui; do
	case "$ui" in
		$'\x1b')    # Handle ESC sequence.
		# Flush read. We account for sequences for Fx keys as
		# well. 6 should suffice far more then enough.
		read -rsn1 -t 0.1 tmp
		if [[ "$tmp" == "[" ]]; then
			read -rsn1 -t 0.1 tmp
			case "$tmp" in
			"A") tiltup;;
			"B") tiltdown;;
			"C") panright;;
			"D") panleft;;
			esac
		fi
		# Flush "stdin" with 0.1  sec timeout.
	read -rsn5 -t 0.1
        ;;
	# Other one byte (char) cases. Here only quit.
	r) tiltreset
	panreset
	;;
	q) break;;
esac
done
}

# uvcdynctrl -s 'Pan (relative)' -- -1500

while test $# -gt 0; do
		case "$1" in
			-h|--help)
					version
					echo "options:"
					echo -e "-h, --help\tIts what youre looking at!"
					echo -e "-l, --led\tChange LED mode (on, off, blink)"
					echo -e "-p, --pan\tPan the camera (left, right, reset)"
					echo -e "-t, --tilt\tTilt the camera (up, down, reset)"
					echo -e "-k, --key\tControl tilt/pan with keyboard arrows"
					exit 0
					;;
			-l|--led)
				case "$2" in
					on)
						ledon
						exit 0
						;;
					off)
						ledoff
						exit 0
						;;
					blink)
						ledblink
						exit 0;;
					*)
						printf "I dont know what you want to do with the LED..\n"
						exit 1
					esac
					;;
			-p|--pan)
				case "$2" in
					left)
						panleft
						exit 0
						;;
					right)
						panright
						exit 0
						;;
					reset)
						panreset
						exit 0
						;;
					*)
						printf "Thats not a valid direction!\n"
						exit 1
					esac
					;;
			-t|--tilt)
				case "$2" in
					up)
						tiltup
						exit 0
						;;
					down)
						tiltdown
						exit 0
						;;
					reset)
						tiltreset
						exit 0
						;;
					*)
						printf "Thats not a valid direction!\n"
						exit 1
					esac
					;;						
			-k|--key)
					keycontrol
					exit 0
					;;
			*)
					break
					;;
					esac
done
printf "Nothing done.  Use -h for help!\n"
exit 1
