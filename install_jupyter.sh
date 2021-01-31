#!/bin/bash

# run under a virtual environment
pip3 install jupyterlab

jupyter lab --generate-config

# set the password to 'nvidia'
CONFPATH=$HOME/.jupyter/jupyter_notebook_config.json
python3 -c "from notebook.auth.security import set_password; set_password('nvidia', '$CONFPATH')"
