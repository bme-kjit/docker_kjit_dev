#FROM ubuntu:18.04 as ue4engine
# System settings
#RUN echo "fs.inotify.max_user_watches = 524288" >> /etc/sysctl.conf
#RUN sysctl -p --system

# Gnome-terminal and locales
#ENV LANG=en_US.UTF-8
#RUN apt-get update -qq && apt-get install -qy gnome-terminal libcanberra-gtk-module libcanberra-gtk3-module locales
#RUN echo 'LANG=en_US.UTF-8' > '/etc/default/locale' && \
#    locale-gen --lang en_US.UTF-8 && \
#    dpkg-reconfigure --frontend=noninteractive locales && \
#    update-locale LANG=$LANG

# Install make and compilers and extra stuff
#RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
#    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qy \
#    build-essential autoconf automake \
#    sudo vim nano git curl wget tmux \
#    libglvnd0 \
#    libgl1 \
#    libglx0 \
#    libegl1 \
#    libxext6 \
#    libx11-6 \
#    gcc x11-apps git openssh-client libfontconfig1 \
#    emacs python tcpdump telnet byacc flex \
#    iproute2 gdbserver less bison valgrind \
#    libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
#    wget software-properties-common \
#    openssh-server cmake gdb build-essential clang llvm lldb && \
#    apt-get clean -qq && \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -rf /tmp/*
    
#RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
#    DEBIAN_FRONTEND=noninteractive apt install -qqy krb5-user krb5-locales libpam-krb5

#ENV NVIDIA_VISIBLE_DEVICES all
#ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

#RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq
#RUN add-apt-repository ppa:ubuntu-toolchain-r/test
#RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|apt-key add -
#RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main"
#RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
#    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qy \
#    build-essential clang-8 lld-8 g++-7 cmake ninja-build libvulkan1 python python-pip python-dev \
#    python3-dev python3-pip libpng-dev libtiff5-dev libjpeg-dev tzdata sed curl \
#    unzip autoconf libtool rsync libxml2-dev
#RUN pip3 install --user -Iv setuptools==47.3.1 
#RUN pip3 install --user distro
#RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/lib/llvm-8/bin/clang++ 180
#RUN update-alternatives --install /usr/bin/clang clang /usr/lib/llvm-8/bin/clang 180
#WORKDIR /
#COPY UnrealEngine /UnrealEngine_4.24

#ENTRYPOINT /bin/bash

FROM ue4engine:latest as build_ue4
WORKDIR /UnrealEngine_4.24
RUN useradd -ms /bin/bash user
RUN chown -R user /UnrealEngine_4.24
USER user
RUN ./Setup.sh
RUN ./GenerateProjectFiles.sh
RUN make
ENTRYPOINT /bin/bash

FROM build_ue4 as carla_build
USER root
RUN export UE4_ROOT=/UnrealEngine_4.24
ENV UE4_ROOT=/UnrealEngine_4.24
RUN apt-get install -y --no-install-recommends aria2
WORKDIR /
RUN git clone https://github.com/carla-simulator/carla.git carla
RUN git clone https://github.com/carla-simulator/carla-map-editor.git carla_map_simulator
RUN pip3 install setuptools
WORKDIR /carla
RUN chown -R user /carla
USER user
RUN make package
USER root
WORKDIR /carla_map_simulator
RUN chmod +x Update.sh
RUN pip3 install requests
RUN ./Update.sh
RUN chown -R user /carla_map_simulator
USER user
RUN make package
RUN make launch
ENTRYPOINT /bin/bash

