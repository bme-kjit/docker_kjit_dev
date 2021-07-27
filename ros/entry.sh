#!/bin/bash
echo "$HOST_USER:x:$HOST_UID:" >> /etc/group
echo "docker:x:999:$HOST_USER" >> /etc/group

su -c "source /opt/ros/melodic/setup.bash && rosdep update && source $CATKIN_WS/devel/setup.bash" $HOST_USER
su $HOST_USER

