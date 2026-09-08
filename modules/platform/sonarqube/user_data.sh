#!/bin/bash

set -e

LOG_FILE="/var/log/sonarqube-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1


############################################################
# VARIABLES
############################################################

DB_NAME="${db_name}"
DB_USER="${db_user}"

SONARQUBE_VERSION="${sonarqube_version}"
SONARQUBE_PORT="${sonarqube_port}"
JAVA_VERSION="${java_version}"

SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$${SONARQUBE_VERSION}.zip"

echo "Database name: $DB_NAME"
echo "Database user: $DB_USER"
echo "SonarQube version: $SONARQUBE_VERSION"
echo "SonarQube port: $SONARQUBE_PORT"


############################################################
# SYSTEM UPDATE
############################################################

dnf update -y


############################################################
# REQUIRED PACKAGES
############################################################

dnf install -y \
  "java-${JAVA_VERSION}-amazon-corretto" \
  wget \
  unzip \
  jq \
  openssl \
  curl \
  amazon-ssm-agent \
  postgresql16 \
  postgresql16-server \
  postgresql16-contrib


############################################################
# JAVA
############################################################

java -version


############################################################
# SSM
############################################################

systemctl daemon-reload

systemctl enable amazon-ssm-agent

systemctl start amazon-ssm-agent


############################################################
# KERNEL PARAMETERS
############################################################

cat > /etc/sysctl.d/99-sonarqube.conf <<EOF
vm.max_map_count=524288
fs.file-max=131072
EOF

sysctl --system


############################################################
# POSTGRESQL INITIALIZATION
############################################################

if [ ! -f /var/lib/pgsql/data/PG_VERSION ]; then

    sudo -u postgres initdb \
      -D /var/lib/pgsql/data

fi


############################################################
# START POSTGRESQL
############################################################

systemctl enable postgresql

systemctl start postgresql

sleep 10


############################################################
# VERIFY POSTGRESQL
############################################################

sudo -u postgres psql -c "SELECT version();"


############################################################
# CREATE DATABASE USER
############################################################

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then

    echo "PostgreSQL user already exists."

else

    echo "Creating PostgreSQL user without password."

    sudo -u postgres psql <<EOF
CREATE USER "$DB_USER";
EOF

fi


############################################################
# CREATE DATABASE
############################################################

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1; then

    echo "Database $DB_NAME already exists."

else

    sudo -u postgres psql <<EOF
CREATE DATABASE "$DB_NAME"
OWNER "$DB_USER"
ENCODING 'UTF8';
EOF

fi


############################################################
# VERIFY DATABASE
############################################################

sudo -u postgres psql -c "\l"

sudo -u postgres psql -c "\du"


############################################################
# CREATE SONARQUBE USER
############################################################

if id sonarqube >/dev/null 2>&1; then

    echo "SonarQube OS user already exists."

else

    useradd \
      --system \
      --home-dir /opt/sonarqube \
      --shell /sbin/nologin \
      sonarqube

fi


############################################################
# SONARQUBE DIRECTORIES
############################################################

mkdir -p /var/sonarqube/data
mkdir -p /var/sonarqube/temp

chown -R sonarqube:sonarqube /var/sonarqube


############################################################
# DOWNLOAD SONARQUBE
############################################################

cd /opt

rm -f sonarqube.zip

wget \
  --https-only \
  --timeout=60 \
  --tries=3 \
  --progress=dot:giga \
  -O sonarqube.zip \
  "$SONARQUBE_URL"


############################################################
# VERIFY DOWNLOAD
############################################################

if [ ! -s /opt/sonarqube.zip ]; then

    echo "ERROR: SonarQube ZIP download failed."

    exit 1

fi


############################################################
# EXTRACT
############################################################

unzip -q sonarqube.zip


############################################################
# FIND INSTALLATION DIRECTORY
############################################################

SONAR_DIR=$(find /opt \
  -maxdepth 1 \
  -type d \
  -name "sonarqube-*" \
  ! -name "sonarqube" \
  | sort \
  | head -n 1)


if [ -z "$SONAR_DIR" ]; then

    echo "ERROR: SonarQube installation directory not found."

    exit 1

fi


############################################################
# CREATE SYMLINK
############################################################

rm -rf /opt/sonarqube

ln -s "$SONAR_DIR" /opt/sonarqube


############################################################
# OWNERSHIP
############################################################

chown -R sonarqube:sonarqube "$SONAR_DIR"


############################################################
# REMOVE ZIP
############################################################

rm -f /opt/sonarqube.zip


############################################################
# SYSTEM LIMITS
############################################################

cat > /etc/security/limits.d/99-sonarqube.conf <<EOF
sonarqube soft nofile 65536
sonarqube hard nofile 65536

sonarqube soft nproc 4096
sonarqube hard nproc 4096
EOF


############################################################
# CREATE INITIAL SONARQUBE CONFIGURATION
############################################################

cat > /opt/sonarqube/conf/sonar.properties <<EOF

sonar.jdbc.username=$DB_USER

sonar.jdbc.url=jdbc:postgresql://127.0.0.1:5432/$DB_NAME

sonar.web.host=0.0.0.0

sonar.web.port=$SONARQUBE_PORT

sonar.path.data=/var/sonarqube/data

sonar.path.temp=/var/sonarqube/temp

EOF


chown sonarqube:sonarqube \
  /opt/sonarqube/conf/sonar.properties


############################################################
# SYSTEMD SERVICE
############################################################

cat > /etc/systemd/system/sonarqube.service <<'EOF'
[Unit]
Description=SonarQube Server
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=forking

User=sonarqube
Group=sonarqube

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

Restart=on-failure
RestartSec=10

LimitNOFILE=65536
LimitNPROC=4096

TimeoutStartSec=600

[Install]
WantedBy=multi-user.target
EOF


############################################################
# SYSTEMD
############################################################

systemctl daemon-reload

systemctl enable sonarqube


############################################################
# DO NOT START YET
############################################################

echo "=========================================================="
echo "SonarQube installation prepared."
echo "=========================================================="

echo "Database:"
echo "  Name: $DB_NAME"
echo "  User: $DB_USER"
echo "  Host: 127.0.0.1"
echo "  Port: 5432"

echo ""
echo "IMPORTANT:"
echo "Database password has NOT been generated."
echo "Database password has NOT been stored in Terraform."
echo "Database password has NOT been stored in Secrets Manager."

echo ""
echo "Next step:"
echo "Connect using SSM and manually set the PostgreSQL password."

echo ""
echo "After setting the password, configure:"
echo "/opt/sonarqube/conf/sonar.properties"

echo ""
echo "Then start:"
echo "systemctl start sonarqube"

echo "=========================================================="
