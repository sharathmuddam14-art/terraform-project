```bash
#!/bin/bash

set -e

LOG_FILE="/var/log/sonarqube-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=================================================="
echo "Starting SonarQube installation"
echo "=================================================="


# ==================================================
# VARIABLES
# ==================================================

DB_NAME="sonarqube"
DB_USER="sonarqube"

SONARQUBE_VERSION="26.8.0.126808"

SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$${SONARQUBE_VERSION}.zip"

echo "Database name: $DB_NAME"
echo "Database user: $DB_USER"
echo "SonarQube version: $SONARQUBE_VERSION"
echo "SonarQube URL: $SONARQUBE_URL"


# ==================================================
# SYSTEM UPDATE
# ==================================================

echo "=================================================="
echo "Updating operating system"
echo "=================================================="

dnf update -y


# ==================================================
# INSTALL REQUIRED PACKAGES
# ==================================================

echo "=================================================="
echo "Installing required packages"
echo "=================================================="

dnf install -y \
  java-21-amazon-corretto \
  wget \
  unzip \
  jq \
  openssl \
  awscli \
  amazon-ssm-agent \
  postgresql16 \
  postgresql16-server \
  postgresql16-contrib


# ==================================================
# VERIFY JAVA
# ==================================================

echo "=================================================="
echo "Checking Java"
echo "=================================================="

java -version


# ==================================================
# START SSM AGENT
# ==================================================

echo "=================================================="
echo "Starting SSM Agent"
echo "=================================================="

systemctl daemon-reload

systemctl enable amazon-ssm-agent

systemctl start amazon-ssm-agent

systemctl status amazon-ssm-agent --no-pager || true


# ==================================================
# CONFIGURE KERNEL PARAMETERS
# ==================================================
# SonarQube uses Elasticsearch internally.
# Current SonarQube versions require sufficient
# virtual memory mappings and file descriptors.

echo "=================================================="
echo "Configuring kernel parameters"
echo "=================================================="

cat > /etc/sysctl.d/99-sonarqube.conf <<EOF

vm.max_map_count=524288
fs.file-max=131072

EOF

sysctl --system


# ==================================================
# INITIALIZE POSTGRESQL
# ==================================================

echo "=================================================="
echo "Initializing PostgreSQL"
echo "=================================================="

if [ ! -f /var/lib/pgsql/data/PG_VERSION ]; then

    echo "PostgreSQL database cluster does not exist."

    sudo -u postgres initdb \
      -D /var/lib/pgsql/data

else

    echo "PostgreSQL database cluster already exists."

fi


# ==================================================
# START POSTGRESQL
# ==================================================

echo "=================================================="
echo "Starting PostgreSQL"
echo "=================================================="

systemctl enable postgresql

systemctl start postgresql

sleep 10

systemctl status postgresql --no-pager || true


# ==================================================
# VERIFY POSTGRESQL
# ==================================================

echo "=================================================="
echo "Testing PostgreSQL"
echo "=================================================="

sudo -u postgres psql -c "SELECT version();"


# ==================================================
# GENERATE DATABASE PASSWORD
# ==================================================

echo "=================================================="
echo "Generating PostgreSQL password"
echo "=================================================="

DB_PASSWORD=$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9' | head -c 32)

if [ -z "$DB_PASSWORD" ]; then

    echo "ERROR: Failed to generate database password."

    exit 1

fi

echo "Database password generated successfully."


# ==================================================
# CREATE POSTGRESQL USER
# ==================================================

echo "=================================================="
echo "Creating PostgreSQL user"
echo "=================================================="

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1; then

    echo "PostgreSQL user already exists."

    sudo -u postgres psql <<EOF
ALTER USER $${DB_USER} WITH PASSWORD '$${DB_PASSWORD}';
EOF

else

    echo "Creating PostgreSQL user..."

    sudo -u postgres psql <<EOF
CREATE USER $${DB_USER} WITH PASSWORD '$${DB_PASSWORD}';
EOF

fi


# ==================================================
# CREATE SONARQUBE DATABASE
# ==================================================

echo "=================================================="
echo "Creating SonarQube database"
echo "=================================================="

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1; then

    echo "Database $DB_NAME already exists."

else

    sudo -u postgres psql <<EOF
CREATE DATABASE $${DB_NAME}
OWNER $${DB_USER}
ENCODING 'UTF8';
EOF

fi


# ==================================================
# VERIFY DATABASE
# ==================================================

echo "=================================================="
echo "Checking SonarQube database"
echo "=================================================="

sudo -u postgres psql -c "\l" | grep "$DB_NAME" || true

echo "Checking SonarQube database owner..."

sudo -u postgres psql -c "\du" | grep "$DB_USER" || true


# ==================================================
# STORE DATABASE CREDENTIALS IN AWS SECRETS MANAGER
# ==================================================

echo "=================================================="
echo "Storing database credentials in Secrets Manager"
echo "=================================================="

SECRET_JSON=$(jq -n \
  --arg username "$DB_USER" \
  --arg password "$DB_PASSWORD" \
  --arg database "$DB_NAME" \
  --arg host "127.0.0.1" \
  --arg port "5432" \
  '{
    username: $username,
    password: $password,
    database: $database,
    host: $host,
    port: $port
  }')

aws secretsmanager put-secret-value \
  --secret-id "${secret_arn}" \
  --secret-string "$SECRET_JSON" \
  --region "${aws_region}"

echo "Database credentials stored in Secrets Manager successfully."


# ==================================================
# REMOVE PASSWORD FROM SHELL VARIABLE
# ==================================================

unset DB_PASSWORD


# ==================================================
# CREATE SONARQUBE LINUX USER
# ==================================================

echo "=================================================="
echo "Creating SonarQube operating-system user"
echo "=================================================="

if id sonarqube >/dev/null 2>&1; then

    echo "SonarQube OS user already exists."

else

    useradd \
      --system \
      --home-dir /opt/sonarqube \
      --shell /sbin/nologin \
      sonarqube

fi


# ==================================================
# CREATE SONARQUBE DIRECTORIES
# ==================================================

echo "=================================================="
echo "Creating SonarQube directories"
echo "=================================================="

mkdir -p /var/sonarqube/data
mkdir -p /var/sonarqube/temp

chown -R sonarqube:sonarqube /var/sonarqube


# ==================================================
# DOWNLOAD SONARQUBE
# ==================================================

echo "=================================================="
echo "Downloading SonarQube"
echo "=================================================="

cd /opt

rm -f sonarqube.zip

wget \
  --https-only \
  --timeout=60 \
  --tries=3 \
  --progress=dot:giga \
  -O sonarqube.zip \
  "$SONARQUBE_URL"


# ==================================================
# VERIFY DOWNLOAD
# ==================================================

echo "=================================================="
echo "Verifying SonarQube download"
echo "=================================================="

if [ ! -s /opt/sonarqube.zip ]; then

    echo "ERROR: SonarQube ZIP download failed."

    exit 1

fi

echo "SonarQube ZIP downloaded successfully."

ls -lh /opt/sonarqube.zip


# ==================================================
# EXTRACT SONARQUBE
# ==================================================

echo "=================================================="
echo "Extracting SonarQube"
echo "=================================================="

unzip -q sonarqube.zip


# ==================================================
# FIND EXTRACTED DIRECTORY
# ==================================================

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

echo "SonarQube installation directory:"
echo "$SONAR_DIR"


# ==================================================
# CREATE /opt/sonarqube SYMLINK
# ==================================================

rm -rf /opt/sonarqube

ln -s "$SONAR_DIR" /opt/sonarqube


# ==================================================
# SET OWNERSHIP
# ==================================================

echo "=================================================="
echo "Setting SonarQube ownership"
echo "=================================================="

chown -R sonarqube:sonarqube "$SONAR_DIR"


# ==================================================
# REMOVE ZIP FILE
# ==================================================

rm -f /opt/sonarqube.zip


# ==================================================
# CONFIGURE SONARQUBE DATABASE
# ==================================================

echo "=================================================="
echo "Configuring SonarQube database"
echo "=================================================="

cat > /opt/sonarqube/conf/sonar.properties <<EOF

# ==================================================
# DATABASE CONFIGURATION
# ==================================================

sonar.jdbc.username=$${DB_USER}

sonar.jdbc.password=$${DB_PASSWORD}

sonar.jdbc.url=jdbc:postgresql://127.0.0.1:5432/$${DB_NAME}


# ==================================================
# SONARQUBE WEB SERVER
# ==================================================

sonar.web.host=0.0.0.0

sonar.web.port=9000


# ==================================================
# SONARQUBE DATA DIRECTORIES
# ==================================================

sonar.path.data=/var/sonarqube/data

sonar.path.temp=/var/sonarqube/temp

EOF


# ==================================================
# SET CONFIGURATION OWNERSHIP
# ==================================================

chown sonarqube:sonarqube \
  /opt/sonarqube/conf/sonar.properties


# ==================================================
# VERIFY SONARQUBE CONFIGURATION
# ==================================================

echo "=================================================="
echo "Checking SonarQube configuration"
echo "=================================================="

grep -E \
  '^sonar.jdbc.username|^sonar.jdbc.url|^sonar.web.host|^sonar.web.port|^sonar.path.data|^sonar.path.temp' \
  /opt/sonarqube/conf/sonar.properties


# ==================================================
# SYSTEM LIMITS
# ==================================================

echo "=================================================="
echo "Configuring system limits"
echo "=================================================="

cat > /etc/security/limits.d/99-sonarqube.conf <<EOF

sonarqube soft nofile 65536
sonarqube hard nofile 65536

sonarqube soft nproc 4096
sonarqube hard nproc 4096

EOF


# ==================================================
# CREATE SYSTEMD SERVICE
# ==================================================

echo "=================================================="
echo "Creating SonarQube systemd service"
echo "=================================================="

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


# ==================================================
# RELOAD SYSTEMD
# ==================================================

echo "=================================================="
echo "Reloading systemd"
echo "=================================================="

systemctl daemon-reload


# ==================================================
# ENABLE SONARQUBE
# ==================================================

echo "=================================================="
echo "Enabling SonarQube"
echo "=================================================="

systemctl enable sonarqube


# ==================================================
# START SONARQUBE
# ==================================================

echo "=================================================="
echo "Starting SonarQube"
echo "=================================================="

systemctl start sonarqube


# ==================================================
# WAIT FOR SONARQUBE
# ==================================================

echo "=================================================="
echo "Waiting for SonarQube to become available"
echo "=================================================="

SONARQUBE_READY=false

for i in {1..60}; do

    echo "Checking SonarQube... attempt $i/60"

    if curl -sf \
      http://localhost:9000/api/system/status \
      >/dev/null 2>&1; then

        echo "SonarQube is responding."

        SONARQUBE_READY=true

        break

    fi

    sleep 10

done


# ==================================================
# SONARQUBE STATUS
# ==================================================

echo "=================================================="
echo "SonarQube service status"
echo "=================================================="

systemctl status sonarqube --no-pager || true


# ==================================================
# POSTGRESQL STATUS
# ==================================================

echo "=================================================="
echo "PostgreSQL service status"
echo "=================================================="

systemctl status postgresql --no-pager || true


# ==================================================
# LISTENING PORTS
# ==================================================

echo "=================================================="
echo "Listening ports"
echo "=================================================="

ss -lntp || true


# ==================================================
# FINAL SONARQUBE CHECK
# ==================================================

if [ "$SONARQUBE_READY" = true ]; then

    echo "=================================================="
    echo "SonarQube installation completed successfully."
    echo "SonarQube is available on port 9000."
    echo "=================================================="

else

    echo "=================================================="
    echo "WARNING: SonarQube did not become ready."
    echo "Check:"
    echo "  systemctl status sonarqube"
    echo "  journalctl -u sonarqube"
    echo "  /opt/sonarqube/logs/"
    echo "=================================================="

    exit 1

fi
```

