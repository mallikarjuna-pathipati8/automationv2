#!/bin/bash

        source ./common.sh
        echo "$(timestamp) [INFO] Script is started" | tee -a "$log_file"
        cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
        validate $? "Copy and Pasted rabbitmq.repo"

        dnf install erlang rabbitmq-server -y &>> "$log_file"
        validate $? "rabbitmq Install" 


        systemctl enable rabbitmq-server &>> "$log_file"
        validate $? "rabbitmq Enable" 
        systemctl start rabbitmq-server &>> "$log_file"
        validate $? "rabbitmq Start" 

        # Verify roboshop user exist 
        rabbitmqctl list_users | grep -qw "roboshop"
        
        if [ "$?" -ne 0 ]; then       
        rabbitmqctl add_user roboshop roboshop123 &>> "$log_file"
        validate $? "rabbitmq add user" 
        else 
        echo -e "$(timestamp) [INFO] User is alredy exist ${Y}Skipping${N}"
        fi

        rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> "$log_file"
        validate $? "rabbitmq Set Permission" 

        total_time



        