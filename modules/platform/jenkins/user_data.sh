#!/bin/bash

set -e

LOG_FILE="/var/log/jenkins-install.log"

# Send all output to the Jenkins installation log
exec >> "$LOG_FILE" 2>&1

echo "============================================================"
echo "Starting Jenkins installation..."
echo "============================================================"

############################################################
# VARIABLES
############################################################

JAVA_VERSION="${java_version}"
JENKINS_PACKAGE="${jenkins_package}"
JENKINS_PORT="${jenkins_port}"

echo "Java version: $JAVA_VERSION"
echo "Jenkins package: $JENKINS_PACKAGE"
echo "Jenkins port: $JENKINS_PORT"

############################################################
# INSTALL REQUIRED PACKAGES
############################################################

echo "Installing required packages..."

dnf install -y \
  "java-$JAVA_VERSION-amazon-corretto" \
  fontconfig \
  wget \
  git

echo "Required packages installed successfully."

############################################################
# START SSM AGENT
############################################################

echo "Starting Amazon SSM Agent..."

systemctl daemon-reload
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo "Amazon SSM Agent started successfully."

############################################################
# JAVA VERIFICATION
############################################################

echo "Checking Java installation..."

java -version

echo "Java verification completed successfully."

############################################################
# JENKINS REPOSITORY
############################################################

echo "Configuring Jenkins repository..."

wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

rpm --import \
  https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Jenkins repository configured successfully."

############################################################
# INSTALL JENKINS
############################################################

echo "Installing Jenkins..."

dnf install -y "$JENKINS_PACKAGE"

echo "Jenkins package installed successfully."

############################################################
# CONFIGURE JENKINS PORT
############################################################

echo "Configuring Jenkins port: $JENKINS_PORT"

mkdir -p /etc/systemd/system/jenkins.service.d

cat > /etc/systemd/system/jenkins.service.d/override.conf <<EOF
[Service]
Environment="JENKINS_PORT=$JENKINS_PORT"
EOF

echo "Jenkins port configuration completed."

############################################################
# START JENKINS
############################################################

echo "Starting Jenkins service..."

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

sleep 15

############################################################
# VERIFY JENKINS
############################################################

echo "Checking Jenkins service status..."

systemctl status jenkins --no-pager

echo "Checking Jenkins listening port..."

ss -lntp | grep ":$JENKINS_PORT" || true

############################################################
# JENKINS INITIAL ADMIN PASSWORD
############################################################

if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "Jenkins initial admin password file created successfully."
else
    echo "WARNING: Jenkins initial admin password file not found yet."
fi

############################################################
# COMPLETION
############################################################

echo "============================================================"
echo "Jenkins installation completed successfully."
echo "============================================================"
