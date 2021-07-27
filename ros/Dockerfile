ARG BASE_IMG=pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel

FROM $BASE_IMG
LABEL maintainer="szoke.laszlo@kjk.bme.hu"
LABEL docker_image_name="Pytorch remote development"
LABEL description="This container is created to use SUMO with Pytorch or TensorFlow and Keras"

# System settings
RUN echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf
RUN sysctl -p --system

# Gnome-terminal and locales
ENV LANG=en_US.UTF-8
RUN apt-get update -qq && apt-get install -qy gnome-terminal libcanberra-gtk-module libcanberra-gtk3-module locales
RUN echo 'LANG=en_US.UTF-8' > '/etc/default/locale' && \
    locale-gen --lang en_US.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG

# Install make and compilers and extra stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qy \
    build-essential autoconf automake \
    sudo vim nano git curl wget tmux \
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    gcc x11-apps git openssh-client libfontconfig1 \
    emacs python tcpdump telnet byacc flex \
    iproute2 gdbserver less bison valgrind \
    libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
    openssh-server cmake gdb build-essential clang llvm lldb && \
    apt-get clean -qq && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
    
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt install -qqy krb5-user krb5-locales libpam-krb5

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

RUN echo "PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /etc/environment
RUN echo "PYTHONPATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> /etc/environment

RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qy \
    ros-melodic-desktop-full python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential && \
    apt-get clean -qq && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
ENV ROS_PYTHON_VERSION=3
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash"
RUN rosdep init

RUN conda update -n base -c defaults conda
RUN conda install pandas
#RUN conda install tensorflow-gpu==2.1.0
#RUN conda install tensorflow-estimator==2.1.0

COPY entry.sh /entry.sh
RUN chmod +x /entry.sh
ENTRYPOINT /entry.sh
