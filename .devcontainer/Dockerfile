##############################################
# Created from template ros2.dockerfile.jinja
##############################################

###########################################
# Base image 
###########################################
FROM ubuntu:22.04 AS base

ARG WORKSPACE

ENV DEBIAN_FRONTEND=noninteractive

# Install language
RUN apt-get update && apt-get install -y \
        locales \
        && locale-gen en_US.UTF-8 \
        && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
        && rm -rf /var/lib/apt/lists/*
ENV LANG en_US.UTF-8

# Install timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
        && export DEBIAN_FRONTEND=noninteractive \
        && apt-get update \
        && apt-get install -y tzdata \
        && dpkg-reconfigure --frontend noninteractive tzdata \
        && rm -rf /var/lib/apt/lists/*

# Install ROS2
RUN apt-get update && apt-get install -y \
        curl \
        gnupg2 \
        lsb-release \
        sudo \
        && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null \
        && apt-get update && apt-get install -y \
#        ros-humble-ros-base \
        python3-argcomplete \
        && rm -rf /var/lib/apt/lists/*


ENV ROS_DISTRO=humble
ENV AMENT_PREFIX_PATH=${WORKSPACE}
ENV COLCON_PREFIX_PATH=${WORKSPACE}
ENV LD_LIBRARY_PATH=${WORKSPACE}/install/lib
ENV PATH=${WORKSPACE}/install/bin:$PATH
ENV PYTHONPATH=${WORKSPACE}/install/lib/python3.10/site-packages
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2
ENV DEBIAN_FRONTEND=

###########################################
#  Develop image 
###########################################
FROM base AS dev

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
        bash-completion \
        build-essential \
        cmake \
        gdb \
        git \
        pylint \
        python3-argcomplete \
        python3-colcon-common-extensions \
        python3-pip \
        python3-rosdep \
        python3-vcstool \
        python3-flake8-docstrings \
        python3-pip \
        python3-pytest-cov \
        ros-dev-tools\
        python3-flake8-blind-except \
        python3-flake8-builtins \
        python3-flake8-class-newline \
        python3-flake8-comprehensions \
        python3-flake8-deprecated \
        python3-flake8-import-order \
        python3-flake8-quotes \
        python3-pytest-repeat \
        python3-pytest-rerunfailures \
        vim \
        wget \
        libconsole-bridge-dev \
        ##
        # libspdlog1 \
        # libtinyxml-dev \
        ##
        # Install ros distro testing packages
        # ros-humble-ament-lint \
        # ros-humble-launch-testing \
        # ros-humble-launch-testing-ament-cmake \
        # ros-humble-launch-testing-ros \
        python3-autopep8 \
        && rm -rf /var/lib/apt/lists/* \
        # && rosdep init || echo "rosdep already initialized" \
        # Update pydocstyle
        && pip install --upgrade pydocstyle



ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
        && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
        # [Optional] Add sudo support for the non-root user
        && apt-get update \
        && apt-get install -y sudo \
        && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
        && chmod 0440 /etc/sudoers.d/$USERNAME \
        # Cleanup
        && rm -rf /var/lib/apt/lists/* \
        && echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc \
        && echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> /home/$USERNAME/.bashrc

ENV DEBIAN_FRONTEND=
ENV AMENT_CPPCHECK_ALLOW_SLOW_VERSIONS=1

# RUN apt-get update && rosdep init

# USER ros

# RUN /bin/bash -c "rosdep update"
# RUN /bin/bash -c "rosdep install --from-paths src --ignore-src -y --skip-keys /"fastcdr rti-connext-dds-6.0.1 urdfdom_headers/""


# RUN HOME=/home/ros && \
#         rosdep update

# RUN mkdir -p /home/ros/workspace/src && \
#         rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

# ###########################################
# #  Full image 
# ###########################################
# FROM dev AS full

# ENV DEBIAN_FRONTEND=noninteractive
# Install the full release
# RUN apt-get update && apt-get install -y \
#         ros-humble-desktop \
#         && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=

# ###########################################
# #  Full+Gazebo image 
# ###########################################
# FROM full AS gazebo

# ENV DEBIAN_FRONTEND=noninteractive
# # Install gazebo
# RUN apt-get update && apt-get install -q -y \
#         lsb-release \
#         wget \
#         gnupg \
#         sudo \
#         && wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
#         && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
#         && apt-get update && apt-get install -q -y \
#         ros-humble-gazebo* \
#         && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=

# ##########################################
#  Full+Gazebo+Nvidia image 
# ##########################################

# FROM gazebo AS gazebo-nvidia

# ################
# # Expose the nvidia driver to allow opengl 
# # Dependencies for glvnd and X11.
# ################
# RUN apt-get update \
#         && apt-get install -y -qq --no-install-recommends \
#         libglvnd0 \
#         libgl1 \
#         libglx0 \
#         libegl1 \
#         libxext6 \
#         libx11-6

# # Env vars for the nvidia-container-runtime.
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
# ENV QT_X11_NO_MITSHM 1

# ** [Optional] Uncomment this section to install additional packages. **
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install --no-install-recommends <your-package-list-here> \
#    #
#    # Clean up
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=dialog

# Set up auto-source of workspace for ros user

# RUN echo "if [ -f ${WORKSPACE}/install/setup.bash ]; then source ${WORKSPACE}/install/setup.bash; fi" >> /home/ros/.bashrc
