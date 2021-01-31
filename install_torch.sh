#!/bin/bash

sudo apt-get install -y libjpeg-dev zlib1g-dev
sudo apt-get install -y libopenblas-base libopenmpi-dev 

# Download package wheel file for torch v1.7.0 from Nvidia
wget https://nvidia.box.com/shared/static/cs3xn3td6sfgtene6jdvsxlr366m2dhq.whl -O torch-1.7.0-cp36-cp36m-linux_aarch64.whl

# install torch from wheel file
pip3 install torch-1.7.0-cp36-cp36m-linux_aarch64.whl

# Now install torchvision from the source code

# ffmpeg is isstalled by Jetpack
# we need the following packages for torchvision
sudo apt-get install libavcodec-dev libswscale-dev

# For torch v1.7.0, choose torchvision 0.8.0. Get the source code and then install the package

git clone -b v0.8.0 https://github.com/pytorch/vision torchvision
cd torchvision
python3 setup.py install

