## This is an example of building the docker with the target image sumo for bme use.
# SUMO  image
docker build --build-arg LOC=bme --build-arg TEMP_IMAGE=sumo -t sumo-dev --target final_image .
# carla image
#docker build --build-arg LOC=bme --build-arg CARLA_BASE=sumo --build-arg TEMP_IMAGE=carla -t carla-dev --target final_image .
# ros + carla  image
#docker build --build-arg LOC=bme --build-arg CARLA_BASE=python --build-arg ROS_BASE=carla --build-arg TEMP_IMAGE=ros  -t carla-ros-dev --target final_image .
# ros + carla + sumo image
#docker build --build-arg LOC=bme --build-arg CARLA_BASE=sumo --build-arg ROS_BASE=carla --build-arg TEMP_IMAGE=ros -t sumo-carla-ros-dev --target final_image .
# ros image
#docker build --build-arg LOC=bme --build-arg CARLA_BASE=sumo --build-arg ROS_BASE=python --build-arg TEMP_IMAGE=ros -t ros-dev --target final_image .

#Use this line for carla server build
#docker build --build-arg LOC=bme -t carla_server --target carla_server .
