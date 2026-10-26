#!/bin/bash

        source ./common.sh

        check_root

        echo "$(timestamp) [INFO] Script is started" | tee -a "$log_file"
        cp mongo.repo /etc/yum.repos.d/mongo.repo 
        validate $? "Adding Mongo Repo"

        dnf install mongodb-org -y &>> "$log_file"
        validate $? "Installing Mongodb"

        systemctl enable mongod &>> "$log_file"
        validate $? "enable mongodb"
        systemctl start mongod &>> "$log_file"
        validate $? "start mongodb"

        sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> "$log_file"
        validate $? "Replace  mongod.conf with 127.0.0.1 with 0.0.0.0"

        systemctl restart mongod &>> "$log_file"
        validate $? "Restarting Mongodb"
        total_time
       