#!/usr/bin/env bash

echo "Install varius projects"

sudo echo "192.168.33.10 atlas
192.168.33.10 gracire
192.168.33.10 redwood
192.168.33.10 schuss
192.168.33.10 mauritius" >> /etc/hosts

vagrant up
