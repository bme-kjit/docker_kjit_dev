#!/bin/bash
echo "$HOST_USER:x:$HOST_UID:" >> /etc/group
echo "docker:x:999:$HOST_USER" >> /etc/group

su -c "echo 'source /opt/ros/noetic/setup.bash && rosdep update && source $CATKIN_WS/devel/setup.bash' >> /home/$HOST_USER/.bashrc" $HOST_USER
su $HOST_USER
source /opt/ros/noetic/setup.bash && rosdep update && source $CATKIN_WS/devel/setup.bash
