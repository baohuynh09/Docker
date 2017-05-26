#!/bin/bash

# ------------------------------------------------------------------------#

# File Name : setup_bash_completion.sh

# Creation Date : 24-05-2017

# Last Modified : Wed 24 May 2017 02:09:47 PM +07

# Description :

# Created By : BaoHuynh-xbaotha (huynhthaibao07@gmail.com)

# ------------------------------------------------------------------------#

#------------------------------------------ #
#              MAIN FUNCTION                #
#------------------------------------------ #
PATH_DIR=$(pwd)
sudo ln -s $PATH_DIR/docker-machine-prompt.bash /etc/bash_completion.d/docker-machine-prompt.bash
sudo ln -s $PATH_DIR/docker-machine-wrapper.bash /etc/bash_completion.d/docker-machine-wrapper.bash
sudo ln -s $PATH_DIR/docker-machine.bash /etc/bash_completion.d/docker-machine.bash
