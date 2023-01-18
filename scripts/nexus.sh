#!/bin/bash
sudo yum install java-1.8.0-openjdk.x86_64 wget -y   
sudo mkdir -p /opt/nexus/   
sudo mkdir -p /tmp/nexus/                           
cd /tmp/nexus/
NEXUSURL="https://download.sonatype.com/nexus/3/nexus-3.45.0-01-unix.tar.gz"
sudo wget $NEXUSURL -O nexus.tar.gz
EXTOUT=`sudo tar -xzvf nexus.tar.gz`
NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`
sudo rm -rf /tmp/nexus/nexus.tar.gz
sudo rsync -avzh /tmp/nexus/ /opt/nexus/
sudo useradd nexus
sudo chown -R nexus.nexus /opt/nexus 
sudo touch ../../etc/systemd/system/nexus.service
sudo chmod 777 ../../etc/systemd/system/nexus.service
cat <<EOT>> ../../etc/systemd/system/nexus.service
[Unit]                                                                          
Description=nexus service                                                       
After=network.target                                                            
                                                                  
[Service]                                                                       
Type=forking                                                                    
LimitNOFILE=65536                                                               
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start                                  
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop                                    
User=nexus                                                                      
Restart=on-abort                                                                
                                                                  
[Install]                                                                       
WantedBy=multi-user.target                                                      
EOT
sudo chmod 777 ../../opt/nexus/$NEXUSDIR/bin/nexus.rc
sudo echo 'run_as_user="nexus"' > ../../opt/nexus/$NEXUSDIR/bin/nexus.rc
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus