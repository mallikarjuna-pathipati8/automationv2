#!/bin/bash

   source ./common.sh
   check_root
    echo "$(timestamp) Script Started"  | tee -a "$log_file"

    dnf module disable redis -y &>> "$log_file"
    dnf module enable redis:7 -y &>> "$log_file"
    dnf install redis -y &>> "$log_file"
    validate $? "Redis Installation"

    sed -i -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf &>> "$log_file"
    validate $? "Update Redis Config File and Protected Mode Change"

    systemctl enable redis &>> "$log_file"
    validate $? "Redis enable"

    systemctl start redis &>> "$log_file"
    validate $? "Redis Start"

    systemctl restart redis &>> "$log_file"
     validate $? "Redis Restart"

    echo "$(timestamp) [INFO] Script Completed in Seconds ${SECONDS}" | tee -a "$log_file"
    echo "$(timestamp) [INFO] Script is ended" | tee -a "$log_file"

    total_time
