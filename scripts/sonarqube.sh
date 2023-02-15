#!/bin/bash
sudo cp ~/../../etc/sysctl.conf ../../root/sysctl.conf_backup
sudo chmod 777 ~/../../etc/sysctl.conf

cat <<EOT>> ~/../../etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
EOT

sudo cp /etc/security/limits.conf /root/sec_limit.conf_backup
sudo chmod 777 ~/../../etc/security/limits.conf

cat <<EOT> ~/../../etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    409
EOT

sudo apt-get update -y
sudo apt-get autoremove
sudo apt-get install openjdk-11-jdk -y
sudo update-alternatives --config java
java -version

sudo apt-get update -y

sudo mkdir -p /sonarqube/
cd /sonarqube/
sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.3.0.34182.zip
sudo apt-get install zip -y
sudo unzip -o sonarqube-8.3.0.34182.zip -d /opt/
sudo mv /opt/sonarqube-8.3.0.34182/ /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube/ -R
sudo cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup
sudo chmod 777 ~/../../opt/sonarqube/conf/sonar.properties

cat <<EOT> ~/../../opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar.admin@2023
sonar.jdbc.url=jdbc:postgresql://172.31.82.251:5432/sonarqube
#sonar.web.host=0.0.0.0
#sonar.web.port=9000
#sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
#sonar.log.level=INFO
#sonar.path.logs=logs
EOT

sudo touch ~/../../etc/systemd/system/sonarqube.service
sudo chmod 777 ~/../../etc/systemd/system/sonarqube.service

cat <<EOT> ~/../../etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
[Install]
WantedBy=multi-user.target
EOT

sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service
#systemctl start sonarqube.service
#systemctl status -l sonarqube.service
sudo apt-get update -y

sudo apt-get install nginx -y
sudo rm -rf ~/../../etc/nginx/sites-enabled/default
sudo rm -rf ~/../../etc/nginx/sites-available/default
sudo touch ~/../../etc/nginx/sites-enabled/sonarqube.conf
sudo chmod 777 ~/../../etc/nginx/sites-enabled/sonarqube.conf
cat <<EOT> ~/../../etc/nginx/sites-enabled/sonarqube.conf
server{
    listen      80;
    # server_name sonarqube.groophy.in;
    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;
    proxy_buffers 16 64k;
    proxy_buffer_size 128k;
    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
              
        proxy_set_header    Host            $host;
        proxy_set_header    X-Real-IP       $remote_addr;
        proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOT
sudo ln -s ~/../../etc/nginx/sites-enabled/sonarqube.conf /etc/nginx/sites-available/sonarqube.conf
sudo systemctl enable nginx.service
#systemctl restart nginx.service
sudo ufw allow 80,9000,9001/tcp
# echo "System reboot in 30 sec"
# sleep 30
# sudo reboot