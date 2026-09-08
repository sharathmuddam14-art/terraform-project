#!/bin/bash

set -e

LOG_FILE="/var/log/jenkins-install.log"

echo "Starting Jenkins installation..." > "$LOG_FILE"


############################################################
# VARIABLES
############################################################

JAVA_VERSION="${java_version}"
JENKINS_PACKAGE="${jenkins_package}"
JENKINS_PORT="${jenkins_port}"

echo "Java version: $JAVA_VERSION" >> "$LOG_FILE"
echo "Jenkins package: $JENKINS_PACKAGE" >> "$LOG_FILE"
echo "Jenkins port: $JENKINS_PORT" >> "$LOG_FILE"


############################################################
# SYSTEM UPDATE
############################################################

dnf update -y


############################################################
# INSTALL REQUIRED PACKAGES
############################################################

dnf install -y \
  "java-${JAVA_VERSION}-amazon-corretto" \
  fontconfig \
  wget \
  git \
  curl \
  amazon-ssm-agent


############################################################
# START SSM AGENT
############################################################

systemctl daemon-reload

systemctl enable amazon-ssm-agent

systemctl start amazon-ssm-agent


############################################################
# JAVA
############################################################

echo "Java version:" >> "$LOG_FILE"

java -version >> "$LOG_FILE" 2>&1


############################################################
# JENKINS REPOSITORY
############################################################

wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import \
  https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key


############################################################
# INSTALL JENKINS
############################################################

dnf install -y "$JENKINS_PACKAGE"


############################################################
# CONFIGURE JENKINS PORT
############################################################

mkdir -p /etc/systemd/system/jenkins.service.d

cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JENKINS_PORT=$JENKINS_PORT"
EOF


############################################################
# START JENKINS
############################################################

systemctl daemon-reload

systemctl enable jenkins

systemctl start jenkins

sleep 15


############################################################
# VERIFY JENKINS
############################################################

echo "Jenkins service status:" >> "$LOG_FILE"

systemctl status jenkins --no-pager \
  >> "$LOG_FILE" 2>&1

echo "Jenkins installation completed." >> "$LOG_FILE"
