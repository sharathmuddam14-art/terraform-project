#!/bin/bash

set -e

LOG_FILE="/var/log/nexus-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "============================================================"
echo "Starting Nexus installation..."
echo "============================================================"

############################################################
# VARIABLES
############################################################

NEXUS_VERSION="${nexus_version}"
JAVA_VERSION="${java_version}"
NEXUS_PORT="${nexus_port}"

NEXUS_ARCHIVE="nexus-${NEXUS_VERSION}-linux-x86_64.tar.gz"

NEXUS_URL="https://download.sonatype.com/nexus/3/$${NEXUS_ARCHIVE}"

NEXUS_USER="nexus"
NEXUS_HOME="/opt/nexus"

SONATYPE_WORK="/opt/sonatype-work"
NEXUS_DATA="/opt/sonatype-work/nexus3"

NEXUS_DOWNLOAD="/opt/$${NEXUS_ARCHIVE}"

echo "Nexus version: $NEXUS_VERSION"
echo "Java version: $JAVA_VERSION"
echo "Nexus port: $NEXUS_PORT"

############################################################
# INSTALL REQUIRED PACKAGES
############################################################

echo "============================================================"
echo "Installing required packages..."
echo "============================================================"

# Amazon Linux 2023 already contains curl-minimal.
# Do NOT install full curl or git.
# tar and gzip are already available on AL2023.

dnf install -y \
    "java-$${JAVA_VERSION}-amazon-corretto" \
    wget

echo "Required packages installed successfully."

############################################################
# VERIFY JAVA
############################################################

echo "============================================================"
echo "Checking Java installation..."
echo "============================================================"

if ! command -v java >/dev/null 2>&1; then
    echo "ERROR: Java installation failed"
    exit 1
fi

java --version

echo "Java verification completed successfully."

############################################################
# START SSM AGENT
############################################################

echo "============================================================"
echo "Starting Amazon SSM Agent..."
echo "============================================================"

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo "Amazon SSM Agent started successfully."

############################################################
# CREATE NEXUS USER
############################################################

echo "============================================================"
echo "Creating Nexus user..."
echo "============================================================"

if ! id "$NEXUS_USER" >/dev/null 2>&1; then

    useradd \
        --system \
        --home-dir "$NEXUS_HOME" \
        --shell /bin/bash \
        "$NEXUS_USER"

fi

echo "Nexus user created successfully."

############################################################
# CREATE DIRECTORIES
############################################################

echo "============================================================"
echo "Creating Nexus directories..."
echo "============================================================"

mkdir -p /opt

mkdir -p "$SONATYPE_WORK"

mkdir -p "$NEXUS_DATA"

mkdir -p "$NEXUS_DATA/log"

mkdir -p "$NEXUS_DATA/tmp"

mkdir -p "$NEXUS_DATA/etc"

echo "Nexus directories created successfully."

############################################################
# DOWNLOAD NEXUS
############################################################

echo "============================================================"
echo "Downloading Nexus..."
echo "============================================================"

rm -f "$NEXUS_DOWNLOAD"

wget \
    --progress=dot:giga \
    -O "$NEXUS_DOWNLOAD" \
    "$NEXUS_URL"

############################################################
# VERIFY DOWNLOAD
############################################################

echo "============================================================"
echo "Verifying Nexus download..."
echo "============================================================"

if [ ! -s "$NEXUS_DOWNLOAD" ]; then

    echo "ERROR: Nexus archive download failed"

    exit 1

fi

echo "Nexus archive downloaded successfully."

ls -lh "$NEXUS_DOWNLOAD"

############################################################
# VALIDATE ARCHIVE
############################################################

echo "============================================================"
echo "Validating Nexus archive..."
echo "============================================================"

tar -tzf "$NEXUS_DOWNLOAD" >/dev/null

echo "Nexus archive validation successful."

############################################################
# EXTRACT NEXUS
############################################################

echo "============================================================"
echo "Extracting Nexus..."
echo "============================================================"

cd /opt

rm -rf "/opt/nexus-${NEXUS_VERSION}"

tar -xzf "$NEXUS_DOWNLOAD"

echo "Nexus extracted successfully."

############################################################
# FIND NEXUS DIRECTORY
############################################################

echo "============================================================"
echo "Finding Nexus directory..."
echo "============================================================"

NEXUS_DIR=$(find /opt \
    -maxdepth 1 \
    -type d \
    -name "nexus-${NEXUS_VERSION}" \
    | head -n 1)

if [ -z "$NEXUS_DIR" ]; then

    echo "ERROR: Nexus directory not found"

    ls -lah /opt

    exit 1

fi

echo "Nexus directory: $NEXUS_DIR"

############################################################
# VERIFY NEXUS EXECUTABLE
############################################################

echo "============================================================"
echo "Verifying Nexus executable..."
echo "============================================================"

if [ ! -f "$NEXUS_DIR/bin/nexus" ]; then

    echo "ERROR: Nexus executable not found"

    ls -lah "$NEXUS_DIR"

    exit 1

fi

chmod 755 "$NEXUS_DIR/bin/nexus"

echo "Nexus executable verified."

############################################################
# JAVA HOME
############################################################

echo "============================================================"
echo "Detecting Java..."
echo "============================================================"

if [ -x "$NEXUS_DIR/jdk/bin/java" ]; then

    NEXUS_JAVA_HOME="$NEXUS_DIR/jdk"

else

    JAVA_BINARY=$(command -v java)

    if [ -z "$JAVA_BINARY" ]; then

        echo "ERROR: Java executable not found"

        exit 1

    fi

    SYSTEM_JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$JAVA_BINARY")")")

    NEXUS_JAVA_HOME="$SYSTEM_JAVA_HOME"

fi

echo "Nexus JAVA_HOME: $NEXUS_JAVA_HOME"

if [ ! -x "$NEXUS_JAVA_HOME/bin/java" ]; then

    echo "ERROR: Java executable not found at:"
    echo "$NEXUS_JAVA_HOME/bin/java"

    exit 1

fi

"$NEXUS_JAVA_HOME/bin/java" --version

############################################################
# CREATE NEXUS SYMLINK
############################################################

echo "============================================================"
echo "Creating Nexus symlink..."
echo "============================================================"

ln -sfn "$NEXUS_DIR" "$NEXUS_HOME"

echo "Nexus symlink created."

############################################################
# PERMISSIONS
############################################################

echo "============================================================"
echo "Setting Nexus permissions..."
echo "============================================================"

chown -R "$NEXUS_USER:$NEXUS_USER" "$NEXUS_DIR"

chown -R "$NEXUS_USER:$NEXUS_USER" "$SONATYPE_WORK"

echo "Nexus permissions configured."

############################################################
# NEXUS RC
############################################################

echo "============================================================"
echo "Creating nexus.rc..."
echo "============================================================"

cat > "$NEXUS_HOME/bin/nexus.rc" <<'EOF'
run_as_user="nexus"
EOF

chown "$NEXUS_USER:$NEXUS_USER" "$NEXUS_HOME/bin/nexus.rc"

chmod 644 "$NEXUS_HOME/bin/nexus.rc"

############################################################
# NEXUS JVM OPTIONS
############################################################

echo "============================================================"
echo "Creating Nexus JVM options..."
echo "============================================================"

cat > "$NEXUS_HOME/bin/nexus.vmoptions" <<EOF
-Xms1024m
-Xmx2048m
-XX:MaxDirectMemorySize=2048m
-Djava.net.preferIPv4Stack=true
-Djava.awt.headless=true
-Dkaraf.data=$NEXUS_DATA
-Dkaraf.log=$NEXUS_DATA/log
-Djava.io.tmpdir=$NEXUS_DATA/tmp
EOF

chown "$NEXUS_USER:$NEXUS_USER" "$NEXUS_HOME/bin/nexus.vmoptions"

chmod 644 "$NEXUS_HOME/bin/nexus.vmoptions"

############################################################
# NEXUS PORT
############################################################

echo "============================================================"
echo "Configuring Nexus port..."
echo "============================================================"

cat > "$NEXUS_DATA/etc/nexus.properties" <<EOF
application-port=$NEXUS_PORT
EOF

chown "$NEXUS_USER:$NEXUS_USER" \
    "$NEXUS_DATA/etc/nexus.properties"

chmod 644 "$NEXUS_DATA/etc/nexus.properties"

echo "Nexus port configured: $NEXUS_PORT"

############################################################
# SYSTEMD SERVICE
############################################################

echo "============================================================"
echo "Creating Nexus systemd service..."
echo "============================================================"

cat > /etc/systemd/system/nexus.service <<EOF
[Unit]
Description=Nexus Repository Manager
After=network-online.target
Wants=network-online.target

[Service]
Type=forking

User=$NEXUS_USER
Group=$NEXUS_USER

LimitNOFILE=65536
LimitNPROC=65536

Environment="INSTALL4J_JAVA_HOME=$NEXUS_JAVA_HOME"
Environment="JAVA_HOME=$NEXUS_JAVA_HOME"

ExecStart=$NEXUS_HOME/bin/nexus start
ExecStop=$NEXUS_HOME/bin/nexus stop

Restart=on-failure
RestartSec=10

TimeoutStartSec=600
TimeoutStopSec=600

[Install]
WantedBy=multi-user.target
EOF

############################################################
# VERIFY SYSTEMD SERVICE
############################################################

echo "============================================================"
echo "Verifying Nexus systemd service..."
echo "============================================================"

systemd-analyze verify /etc/systemd/system/nexus.service

echo "Nexus systemd service verified."

############################################################
# RELOAD SYSTEMD
############################################################

echo "Reloading systemd..."

systemctl daemon-reload

############################################################
# ENABLE NEXUS
############################################################

echo "============================================================"
echo "Enabling Nexus service..."
echo "============================================================"

systemctl enable nexus

############################################################
# START NEXUS
############################################################

echo "============================================================"
echo "Starting Nexus..."
echo "============================================================"

systemctl start nexus

echo "Nexus start command completed."

############################################################
# WAIT FOR NEXUS
############################################################

echo "============================================================"
echo "Waiting for Nexus to start..."
echo "============================================================"

NEXUS_STARTED=false

for i in {1..60}; do

    if curl -fs \
        "http://127.0.0.1:$${NEXUS_PORT}/" \
        >/dev/null 2>&1; then

        echo "Nexus is responding."

        NEXUS_STARTED=true

        break

    fi

    echo "Waiting for Nexus... $i/60"

    sleep 10

done

############################################################
# STATUS
############################################################

echo "============================================================"
echo "Nexus service status"
echo "============================================================"

systemctl status nexus --no-pager -l || true

echo "============================================================"
echo "Listening ports"
echo "============================================================"

ss -lntp | grep "$NEXUS_PORT" || true

echo "============================================================"
echo "Nexus processes"
echo "============================================================"

ps -ef | grep nexus | grep -v grep || true

echo "============================================================"
echo "Nexus logs"
echo "============================================================"

ls -lh "$NEXUS_DATA/log/" || true

############################################################
# FINAL CHECK
############################################################

if [ "$NEXUS_STARTED" = true ]; then

    echo "============================================================"
    echo "NEXUS INSTALLATION SUCCESSFUL"
    echo "============================================================"

    echo "Version: $NEXUS_VERSION"
    echo "Java: $NEXUS_JAVA_HOME"
    echo "Data: $NEXUS_DATA"
    echo "Port: $NEXUS_PORT"

else

    echo "============================================================"
    echo "ERROR: Nexus did not start"
    echo "============================================================"

    echo "Systemd logs:"

    journalctl -u nexus --no-pager -n 100 || true

    echo "Nexus application logs:"

    find "$NEXUS_DATA/log" \
        -maxdepth 1 \
        -type f \
        -print \
        -exec tail -50 {} \; || true

    exit 1

fi

echo "============================================================"
echo "Nexus userdata completed."
echo "============================================================"
