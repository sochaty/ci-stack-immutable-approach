#!/bin/bash
sudo cp ../../etc/sysctl.conf ../../root/sysctl.conf_backup
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
sudo wget https://builds.openlogic.com/downloadJDK/openlogic-openjdk/11.0.18+10/openlogic-openjdk-11.0.18+10-linux-x64.tar.gz
tar -xvf openlogic-openjdk-11.0.18+10-linux-x64.tar.gz
sudo mkdir -p /usr/lib/jvm/openjdk-11.0.18/
sudo mv openlogic-openjdk-11.0.18+10-linux-x64/* /usr/lib/jvm/openjdk-11.0.18/
sudo chmod 777 ~/../../etc/environment

cat <<EOT>> ~/../../etc/environment
JAVA_HOME="/usr/lib/jvm/openjdk-11.0.18/bin"
EOT

export JAVA_HOME=/usr/lib/jvm/openjdk-11.0.18/bin

. ~/../../etc/environment
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/openjdk-11.0.18/bin/java" 0
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/openjdk-11.0.18/bin/javac" 0
sudo update-alternatives --set java /usr/lib/jvm/openjdk-11.0.18/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/openjdk-11.0.18/bin/javac
java -version

sudo apt-get update -y
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get install postgresql postgresql-contrib -y
#sudo -u postgres psql -c "SELECT version();"
sudo chmod 777 ~/../../etc/postgresql/14/main/postgresql.conf
sudo sed -i '1,/#listen_addresses/s/#listen_addresses/listen_addresses/g' ~/../../etc/postgresql/14/main/postgresql.conf
# sed '0,/foo/s//bar/' file 
# sed '1,/foo/ s/foo/bar/'
sudo sed -i '1,/localhost/s/localhost/*/g' ~/../../etc/postgresql/14/main/postgresql.conf

# sudo chmod 777 ~/../../etc/postgresql/14/main/pg_hba.conf
# cat <<EOT>> ~/../../etc/postgresql/14/main/pg_hba.conf
# # IPv4 remote connections:
# host    all             all             0.0.0.0/0               scram-sha-256
# EOT

sudo systemctl enable postgresql.service
sudo systemctl start  postgresql.service

echo "postgres:admin@2023" | sudo chpasswd
sudo runuser -l postgres -c "createuser sonar"
sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'sonar.admin@2023';"
sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
sudo systemctl restart  postgresql
# sudo reboot