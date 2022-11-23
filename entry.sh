#! /bin/bash
if [ -z "$1" ]; then
    START_SSH=false
else
    START_SSH=$1
    shift
fi

if [ "$START_SSH" = true ]; then
    service ssh start
fi
echo "Please leave this terminal open, go to a new terminal window and run ./start_docker.sh"
su "$@"
