#!/bin/bash
sudo chmod 777 /etc/postgresql/14/main/pg_hba.conf
echo '# IPv4 remote connections:' >> /etc/postgresql/14/main/pg_hba.conf
echo 'host    all             all             10.0.3.0/24               scram-sha-256' >> /etc/postgresql/14/main/pg_hba.conf
echo 'host    all             all             10.0.4.0/24               scram-sha-256' >> /etc/postgresql/14/main/pg_hba.conf
sudo systemctl restart  postgresql.service