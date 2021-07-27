ARG CARLA_VERSION=0.9.11
ARG CARLA_BASE=python
ARG MAP_FILE=https://carla-releases.s3.eu-west-3.amazonaws.com/Linux/AdditionalMaps_$CARLA_VERSION.tar.gz

FROM mwendler/wget as temp_carla

ENV http_proxy=http://172.17.0.1:3128
ENV https_proxy=http://172.17.0.1:3128
ARG MAP_FILE
RUN wget -S --no-check-certificate $MAP_FILE

FROM carlasim/carla:$CARLA_VERSION  as carla_server
ARG CARLA_VERSION
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
ENV http_proxy=http://172.17.0.1:3128
ENV https_proxy=http://172.17.0.1:3128
USER root
RUN apt-get update && apt-get install -y xdg-user-dirs xdg-utils python3-pip && apt-get clean
USER carla
WORKDIR /home/carla
COPY --from=temp_carla /AdditionalMaps_$CARLA_VERSION.tar.gz Import/
COPY carla-package-NGSIM-openDD.tar.gz Import/

RUN ./ImportAssets.sh

FROM ${CARLA_BASE}_img as carla_img
ARG CARLA_VERSION

COPY --from=carla_server /home/carla/PythonAPI/carla/dist/carla-$CARLA_VERSION-py3.7-linux-x86_64.egg /carla_packages/
RUN echo "PYTHONPATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/sumo/tools:/usr/share/sumo:/carla_packages/carla-$CARLA_VERSION-py3.7-linux-x86_64.egg" >> /etc/environment

RUN pip install pygame
