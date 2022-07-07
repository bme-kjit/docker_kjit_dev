# Options: company, bme
ARG LOC

ARG BASE_IMG=pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime
#pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel
# Defining the building bases for the different versions
ARG CARLA_BASE=python
ARG ROS_BASE=carla
# Adding the final layers e.g. extra packages
ARG TEMP_IMAGE=sumo

# in case of carla, use these
ARG CARLA_VERSION=0.9.11
ARG MAP_FILE=https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_$CARLA_VERSION.tar.gz

FROM ${BASE_IMG} AS company_version
ENV http_proxy=http://172.17.0.1:3128
ENV https_proxy=http://172.17.0.1:3128
ENV NO_PROXY=*.bosch.com,127.0.0.1

RUN echo 'Acquire::http::proxy "http://172.17.0.1:3128/";'  >> /etc/apt/apt.conf.d/05proxy && \
    echo 'Acquire::https::proxy "http://172.17.0.1:3128/";'  >> /etc/apt/apt.conf.d/05proxy && \
    echo 'Acquire::ftp::proxy "http://172.17.0.1:3128/";' >> /etc/apt/apt.conf.d/05proxy

FROM ${BASE_IMG} AS bme_version
RUN echo "No proxy setup necessary."

FROM ${LOC}_version AS python_img

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

RUN conda update -n base -c defaults conda
RUN conda install pandas
#RUN conda install tensorflow-gpu==2.1.0
#RUN conda install tensorflow-estimator==2.1.0

ENTRYPOINT /entry.sh

FROM python_img AS sumo_img
LABEL docker_image_name="SUMO environment with Pytorch"
LABEL description="This container is created to use SUMO with Pytorch or TensorFlow and Keras"

RUN apt-get update && \
	apt-get install -y software-properties-common && \
	rm -rf /var/lib/apt/lists/*

# Installing SUMO
RUN add-apt-repository ppa:sumo/stable
RUN apt-get update && apt-get install -y --no-install-recommends \
	sumo \
	sumo-tools \
	sumo-doc

ENV SUMO_HOME /usr/share/sumo
RUN echo "PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/sumo/tools:/usr/share/sumo" >> /etc/environment
RUN echo "PYTHONPATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/sumo/tools:/usr/share/sumo" >> /etc/environment
RUN pip install gym easygui matplotlib opencv-python control


FROM ${TEMP_IMAGE}_img as final_image

RUN pip install gym[atari]
RUN pip install pytorch-lightning-bolts
RUN pip install pytorch-lightning-bolts["extra"]
RUN pip install gym pygame scikit-image
RUN pip install lxml
