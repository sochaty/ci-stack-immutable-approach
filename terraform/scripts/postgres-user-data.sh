#!/bin/bash
sudo chmod 777 /etc/postgresql/14/main/pg_hba.conf
echo '# IPv4 remote connections:' >> /etc/postgresql/14/main/pg_hba.conf
echo 'host    all             all             0.0.0.0/0               scram-sha-256' >> /etc/postgresql/14/main/pg_hba.conf