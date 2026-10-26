#!/bin/bash

        #Get the user id
        source ./common.sh
        check_root
        echo "$(timestamp) [INFO] Script is started" | tee -a "$log_file"

        dnf module enable mysql:8.4 -y &>> "$log_file"
        validate $? "MySQL Module Enable"
        dnf install mysql-server -y&>> "$log_file"
        validate $? "MySQL Install"

        systemctl enable mysqld &>> "$log_file"
        validate $? "MySQL Enable"
        systemctl start mysqld &>> "$log_file"
        validate $? "MySQL Start"

        mysql_secure_installation --set-root-pass RoboShop@1
        validate $? "MySQL Set Root password"

        total_time