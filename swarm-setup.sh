#!/bin/bash

# ------------------------------------------------------------------------#

# File Name : swarm-node-vbox-setup.sh

# Creation Date : 26-05-2017

# Last Modified : Sun 28 May 2017 08:18:23 PM PDT

# Description : automate script to create docker swarm cluster.

# Created By : BaoHuynh-xbaotha (huynhthaibao07@gmail.com)

# ------------------------------------------------------------------------#

#------------------------------------------ #
#          GLOBAL CONFIGURATION             #
#------------------------------------------ #
# Swarm mode using Docker Machine
managers=1
workers=3
driver=virtualbox
# Define memory(MB) for each nodes. Useful for host with low RAM
# If not specify, default memory(MB)=1024
memory=512

#------------------------------------------ #
#           REMOVE CLUSTER SWARM            #
#------------------------------------------ #
RemoveSwarm() {
    # remove manager machines
    echo "======> Remove $managers manager machines ...";
    for node in $(seq 1 $managers);
    do
        echo "======> Remove manager$node machine ...";
        docker-machine rm manager$node;
    done

    # remove worker machines
    echo "======> Remove $workers worker machines ...";
    for node in $(seq 1 $workers);
    do
        echo "======> Remove worker$node machine ...";
        docker-machine rm worker$node;
    done

    # list all machines
    docker-machine ls
}
#------------------------------------------ #
#           CREATE CLUSTER SWARM            #
#------------------------------------------ #
CreateSwarm() {
    # create manager machines
    echo "======> Creating $managers manager machines ...";
    for node in $(seq 1 $managers);
    do
        echo "======> Creating manager$node machine ...";
        docker-machine create -d $driver --virtualbox-memory $memory manager$node;
    done

    # create worker machines
    echo "======> Creating $workers worker machines ...";
    for node in $(seq 1 $workers);
    do
        echo "======> Creating worker$node machine ...";
        docker-machine create -d $driver --virtualbox-memory $memory worker$node;
    done

    # list all machines
    docker-machine ls

    # initialize swarm mode and create a manager
    echo "======> Initializing first swarm manager ..."
    docker-machine ssh manager1 "docker swarm init --listen-addr $(docker-machine ip manager1) --advertise-addr $(docker-machine ip manager1)"

    # get manager and worker tokens
    export manager_token=`docker-machine ssh manager1 "docker swarm join-token manager -q"`
    export worker_token=`docker-machine ssh manager1 "docker swarm join-token worker -q"`

    echo "manager_token: $manager_token"
    echo "worker_token: $worker_token"

    # other masters join swarm
    for node in $(seq 2 $managers);
    do
        echo "======> manager$node joining swarm as manager ..."
        docker-machine ssh manager$node \
            "docker swarm join \
            --token $manager_token \
            --listen-addr $(docker-machine ip manager$node) \
            --advertise-addr $(docker-machine ip manager$node) \
            $(docker-machine ip manager1)"
    done

    # show members of swarm
    docker-machine ssh manager1 "docker node ls"

    # workers join swarm
    for node in $(seq 1 $workers);
    do
        echo "======> worker$node joining swarm as worker ..."
        docker-machine ssh worker$node \
        "docker swarm join \
        --token $worker_token \
        --listen-addr $(docker-machine ip worker$node) \
        --advertise-addr $(docker-machine ip worker$node) \
        $(docker-machine ip manager1)"
    done

    # show members of swarm
    docker-machine ssh manager1 "docker node ls"
}

#------------------------------------------ #
#              MAIN FUNCTION                #
#------------------------------------------ #
case $1 in
    -i|--install)
        CreateSwarm
        ;;
    -u|--uninstall)
        RemoveSwarm
        ;;
    *)
        echo "Not correct options"
        echo "Please use --install/-i or --uninstall/-u"
        echo "Ex: ./swarm-setup -i"
esac
