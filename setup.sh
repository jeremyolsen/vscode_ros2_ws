#!/bin/bash
set -e

vcs import < src/ros2.repos src
sudo apt-get update
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"