# Setup Development Envrionment on Nvidia Jetson Board

This note explains the steps to get the Jetson board ready for PyTorch development.

The first thing is to install the JetPack package. The Nvidia website gives detailed instructions on this. For more information, refer to [https://docs.nvidia.com/jetson/jetpack/install-jetpack/index.html](https://docs.nvidia.com/jetson/jetpack/install-jetpack/index.html)

You can check the jetpack version by examining the file `/etc/nv_tegra_release`.

```
$ cat /etc/nv_tegra_release
# R32 (release), REVISION: 5, GCID: 25531747, BOARD: t186ref, EABI: aarch64, DATE: Sat Nov 07 23:21:05 UTC 2020
```

In my case, JetPack 4.5 (L4T 32.5) is installed. 

## Setup virtual environment

By default, the virtual environment does not include system packages for better isolations. In that case, `sys.path` would not include packages under `/usr/lib/python3/dist-packages`. 

In our setup, we'd like to have system packages. This is so that the packages installed by JetPack such as OpenCV, and TensorRt packages are available under the virtual environtment.

```
python3 -m venv --system-site-packages .devenv

# use virtual environment
source .devenv/bin/activate 
```

## Setup torch and torchvision

Install necessary packages first:

```
pip3 install -r requirements.txt
```

Nvidia provides python package wheel files for torch v1.7.0. See nvidia forum message [https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-7-0-now-available/72048](https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-7-0-now-available/72048) for more information.


Use `install_torch.sh` to install torch version 1.7.0, and to install torchvision from source code.

```
./install_torch.sh
```


## Setup JetCam module

This module from Nvidia provides a unified interface for CSI and USB cameras on Jetson. It uses OpenCV and Gstreamer, which are alraedy installed by JetPack. 

```
./install_jetcam.sh
```

## Setup torch2trt

Since we will use tensorrt to run any neural network inference code, we need to use `torch2trt` package to convert a   PyTorch model to TensorRT. 

```
./install_torch2trt.sh
```


## Setup Jupyter Lab

Use `install_jupyter.sh` to install Jupyter Lab and set up password as `nvidia` (or change it to your own password)

```
./install_jupyter.sh
```

To run the notebook, change directory to your python and notebook workspace, and run the following command

```
jupyter notebook --ip 0.0.0.0 --port 8888 --no-browser
```


## Example code

```python
import torch
from torch2trt import torch2trt
from torchvision.models.resnet18 import resnet18

# create some regular pytorch model...
resnet = torchvision.models.resnet18(pretrained=pretrained)

# create example data
data = torch.ones((1, 3, 224, 224)).cuda()

# convert to TensorRT feeding sample data as input
model_trt = torch2trt(resnet, [data], fp16_mode=True, max_workspace_size=1<<25)

# acquire image data from cv2 (code skipped)
data = preprocess(image)

y_trt = model_trt(data)
```