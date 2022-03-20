#!/bin/sh

#---------------) Colors (----------------#
C=$(printf '\033')
YELLOW="${C}[1;33m"
BLUE="${C}[1;34m"
LG="${C}[1;37m"
DG="${C}[1;90m"
NC="${C}[0m"

#--------------) ProcDump (---------------#
printf "${BLUE} Shows the kernel version and the last time it’s been fully updated.$NC\n"
cat /proc/version
printf "\n"

printf "${BLUE} This provides information as to what process is running on which cpu with their PID.$NC\n"
cat /proc/sched_debug 2>/dev/null || echo "/proc/sched_debug was not found on this system"
printf "\n"

printf "${BLUE} Provides a list of mounted file systems and where other interesting files might be located.$NC\n"
cat /proc/mounts
printf "\n"

printf "${BLUE} Shows the ARP table IP addresses for other internal servers.$NC\n"
cat /proc/net/arp
printf "\n"

printf "${BLUE} Shows the routing table information.$NC\n"
cat /proc/net/route
printf "\n"

printf "${BLUE} List of active connections.\n"
printf "$YELLOW[TCP]$NC\n"
cat /proc/net/tcp
printf "$YELLOW[UDP]$NC\n"
cat /proc/net/udp
printf "\n"

printf "$BLUE Route caching for local IPs and the target’s networking structure.$NC\n"
cat /proc/net/fib_trie
printf "\n"

printf "$BLUE Lists everything that was used to invoke the process.$NC\n"
for i in {1000..2000}
do
  if test -r /proc/$i/cmdline; then
    size=$(cat /proc/$i/cmdline | wc -c)
    if [ $size -gt 0 ]; then
      printf "${LG}PID $i -- FD $(ls /proc/$i/fd 2>/dev/null | wc -l) -- CWD $(realpath /proc/$i/cwd 2>/dev/null | tr -d '\0')$NC\n"
      cat /proc/$i/cmdline | tr -d '\0' && printf "\n"
    fi
  fi
  if test -r /proc/$i/environ; then
    printf "${DG}Environments:\n"
    cat /proc/$i/environ | tr -d '\0' && printf "\n$NC"
  fi
done
