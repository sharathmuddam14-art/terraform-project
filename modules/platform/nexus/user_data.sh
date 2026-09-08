#!/bin/bash

set -e

LOG_FILE="/var/log/nexus-install.log"

exec > >(tee -a "$LOG_FILE") 2>&1


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
# SYSTEM UPDATE
############################################################

dnf update -y


############################################################
# INSTALL REQUIRED PACKAGES
############################################################

dnf install -y \
    "java-$${JAVA_VERSION}-amazon-corretto" \
    wget \
    tar \
    gzip \
    git \
    curl \
    amazon-ssm-agent


############################################################
# START SSM AGENT
############################################################

systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent


############################################################
# CREATE NEXUS USER
############################################################

if ! id "$NEXUS_USER" >/dev/null 2>&1; then
    useradd \
        --system \
        --home-dir "$NEXUS_HOME" \
        --shell /bin/bash \
        "$NEXUS_USER"
fi


############################################################
# CREATE DIRECTORIES
############################################################

mkdir -p /opt
mkdir -p "$SONATYPE_WORK"
mkdir -p "$NEXUS_DATA"
mkdir -p "$NEXUS_DATA/log"
mkdir -p "$NEXUS_DATA/tmp"


############################################################
# DOWNLOAD NEXUS
############################################################

rm -f "$NEXUS_DOWNLOAD"

wget \
    --progress=dot:giga \
    -O "$NEXUS_DOWNLOAD" \
    "$NEXUS_URL"

test -s "$NEXUS_DOWNLOAD"


############################################################
# VALIDATE ARCHIVE
############################################################

tar -tzf "$NEXUS_DOWNLOAD" >/dev/null


############################################################
# EXTRACT
############################################################

cd /opt

tar -xzf "$NEXUS_DOWNLOAD"


############################################################
# FIND NEXUS DIRECTORY
############################################################

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


if [ ! -f "$NEXUS_DIR/bin/nexus" ]; then
    echo "ERROR: Nexus executable not found"
    exit 1
fi


chmod 755 "$NEXUS_DIR/bin/nexus"


############################################################
# JAVA HOME
############################################################

if [ -x "$NEXUS_DIR/jdk/bin/java" ]; then
    NEXUS_JAVA_HOME="$NEXUS_DIR/jdk"
else
    SYSTEM_JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")
    NEXUS_JAVA_HOME="$SYSTEM_JAVA_HOME"
fi


############################################################
# SYMLINK
############################################################

ln -sfn "$NEXUS_DIR" "$NEXUS_HOME"


############################################################
# PERMISSIONS
############################################################

chown -R "$NEXUS_USER:$NEXUS_USER" "$NEXUS_DIR"
chown -R "$NEXUS_USER:$NEXUS_USER" "$SONATYPE_WORK"


############################################################
# NEXUS RC
############################################################

cat > "$NEXUS_HOME/bin/nexus.rc" <<'EOF'
run_as_user="nexus"
EOF

chown "$NEXUS_USER:$NEXUS_USER" "$NEXUS_HOME/bin/nexus.rc"
chmod 644 "$NEXUS_HOME/bin/nexus.rc"


############################################################
# NEXUS JVM OPTIONS
############################################################

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

mkdir -p "$NEXUS_DATA/etc"

cat > "$NEXUS_DATA/etc/nexus.properties" <<EOF
application-port=$NEXUS_PORT
EOF

chown "$NEXUS_USER:$NEXUS_USER" "$NEXUS_DATA/etc/nexus.properties"


############################################################
# SYSTEMD SERVICE
############################################################

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
# START
############################################################

systemd-analyze verify /etc/systemd/system/nexus.service

systemctl daemon-reload

systemctl enable nexus

systemctl start nexus


############################################################
# WAIT FOR NEXUS
############################################################

NEXUS_STARTED=false

for i in {1..60}; do

    if curl -fs \
        "http://127.0.0.1:$${NEXUS_PORT}/" \
        >/dev/null 2>&1; then

        echo "Nexus is responding"

        NEXUS_STARTED=true

        break
    fi

    echo "Waiting for Nexus... $i/60"

    sleep 10

done


############################################################
# STATUS
############################################################

systemctl status nexus --no-pager -l || true

ss -lntp | grep "$NEXUS_PORT" || true

ps -ef | grep nexus | grep -v grep || true

ls -lh "$NEXUS_DATA/log/" || true


############################################################
# FINAL CHECK
############################################################

if [ "$NEXUS_STARTED" = true ]; then

    echo "=========================================="
    echo "NEXUS INSTALLATION SUCCESSFUL"
    echo "=========================================="

    echo "Version: $NEXUS_VERSION"
    echo "Java: $NEXUS_JAVA_HOME"
    echo "Data: $NEXUS_DATA"
    echo "Port: $NEXUS_PORT"

else

    echo "ERROR: Nexus did not start"

    journalctl -u nexus --no-pager -n 100 || true

    exit 1
fi
