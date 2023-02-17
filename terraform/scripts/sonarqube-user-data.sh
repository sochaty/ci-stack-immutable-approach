#!/bin/bash
sed -i '1,/localhost/s/localhost/${postgres_host}/g' /opt/sonarqube/conf/sonar.properties
sudo systemctl restart sonarqube.service