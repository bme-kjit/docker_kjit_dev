#XAUTH file for remote GUI
XAUTH=/tmp/.carla_docker.xauth

DISPLAY=$DISPLAY
echo $DISPLAY
sudo rm -rf $XAUTH
touch $XAUTH

xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | sudo xauth -f $XAUTH nmerge -
sudo chmod 777 $XAUTH
