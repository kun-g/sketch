 #!/bin/bash
clear

printf "User: $USER \t Home: $HOME \t Terminal: $TERM \n"
printf "Services on ring3:\n" # ring3
ls /etc/rc3.d/S*

echo "These users are currently connected:" `w | cut -d " " -f 1 - | grep -v USER | sort -u`
echo

echo "This is `uname -s` running on a `uname -m` processor."
echo

echo "This is the uptime information:"
uptime
echo

echo "Today is `date`, this is week `date +"%V"` "
echo "Calendar for coming 7 days:"
echo "======================="
calendar -f calendar.kun -A 7
echo "======================="

POSPAR1="$1"
POSPAR2="$2"
POSPAR3="$3"

echo "$1 is the first positional parameter, \$1."
echo "$2 is the second positional parameter, \$2."
echo "$3 is the third positional parameter, \$3."
echo
echo "The total number of positional parameters is $#."
