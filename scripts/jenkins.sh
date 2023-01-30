# !/bin/bash
sudo apt-get autoremove
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install openjdk-11-jdk -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get  install jenkins -y
sudo apt-get update
sudo apt-get install -y dotnet-sdk-6.0
###