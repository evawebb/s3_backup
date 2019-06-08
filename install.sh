#!/bin/bash
set -ex

mkdir /usr/local/lib/s3_backup || true
cp s3_backup.rb /usr/local/lib/s3_backup/
cat <<EOF > /usr/local/lib/s3_backup/s3_backup
#!/bin/bash
export BACKUP_DIR='/home/${BACKUP_USER:-$SUDO_USER}/backup_staging/'
export AWS_BIN='$AWS_BIN'
ruby /usr/local/lib/s3_backup/s3_backup.rb
EOF
chmod 755 /usr/local/lib/s3_backup/s3_backup

cp s3-backup.service /etc/systemd/system/
cp s3-backup.timer /etc/systemd/system/
systemctl daemon-reload
systemctl start s3-backup.timer
systemctl enable s3-backup.timer
