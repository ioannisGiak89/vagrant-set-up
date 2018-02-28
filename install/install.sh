#!/usr/bin/env bash

echo "Install varius projects"

sudo echo "192.168.33.10 my_project_name
192.168.33.10 my_project_name_2" >> /etc/hosts

vagrant up
