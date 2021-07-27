## This is an example of building the docker with the target image sumo for bme use.
# SUMO  image
docker tag sumo-dev szokelaszlo95/sumo-dev
# carla image
#docker tag carla-dev szokelaszlo95/carla-dev:latest
# ros + carla  image
#docker tag carla-ros-dev szokelaszlo95/carla-dev:ros
# ros + carla + sumo image
#docker tag sumo-carla-ros-dev szokelaszlo95/carla-dev:ros-sumo

#Use this line for carla server build
#docker tag carla_server szokelaszlo95/carla-dev:server

#docker image push --all-tags szokelaszlo95/carla-dev
docker image push --all-tags szokelaszlo95/sumo-dev
