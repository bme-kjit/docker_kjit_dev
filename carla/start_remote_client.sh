#! /bin/bash

docker_list_raw=`docker ps --filter "ancestor=carla-dev" --filter "name=carla-dev" -q`
docker_list=($docker_list_raw)
if [ ${#docker_list[@]} -gt 1 ]; then
    if [ -z "$1" ]; then
                echo "We have several running docker containers. Please choose one and run this script again."
                docker ps --filter "ancestor=carla-dev"
        else
                echo "We are entering the docker container number $1 with id ${docker_list[$1]}."
            docker exec -it --user=$UID ${docker_list[$1]} /bin/bash
        fi
elif [ ${#docker_list[@]} -eq 0 ]; then
        echo "We have no running docker container, so we start one."
        echo "Update the Xauth file, for forwarding the GUI through tunnel..."
        ./update_xauth.sh
        #XAUTH file for remote GUI
        export XAUTH=/tmp/.carla_docker.xauth
        echo "Starting the client container..../s The server can be reached with 'server'"
      docker-compose -f ./docker-compose.yml run --name carla-dev --rm --service-ports carla_client
else
        echo "We are entering the only running docker container."
    docker exec -it --user=$UID ${docker_list[0]} /bin/bash
fi