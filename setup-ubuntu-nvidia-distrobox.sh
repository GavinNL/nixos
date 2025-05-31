#!/bin/bash

NAME=ubuntu-nvidia

distrobox create --name ${NAME} --additional-flags "-e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=all" --image ubuntu:24.04

INSTALL_SCRIPT=/tmp/install_script_distrobox

cat > ${INSTALL_SCRIPT} <<EOL
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt install -y nvidia-driver-570
sudo apt install -y libxcb-cursor0 xorg xauth x11-apps mesa-utils libxcb-xinerama0 libxkbcommon-x11-0 libxcb-util1 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 python3.12-venv
sudo apt install -y jq cmake gcc-14 g++-14 clang-19 git
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 100
sudo update-alternatives --config gcc
sudo update-alternatives --config g++ 
apt install python3.12-venv
EOL

distrobox enter ${NAME} -- bash ${INSTALL_SCRIPT}
rm ${INSTALL_SCRIPT}
