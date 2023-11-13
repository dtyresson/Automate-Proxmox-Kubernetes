#! /bin/bash

if [ -f "$HOME/.kube/config" ]; then
    echo "$FILE exists."
else 
    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config
fi

