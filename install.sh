#!/bin/bash
set -ex

BACKUP_USER=${BACKUP_USER:-$SUDO_USER}

mkdir /usr/local/lib/s3_backup || true
cp s3_backup.rb /usr/local/lib/s3_backup/
cat <<EOF > /usr/local/lib/s3_backup/s3_backup
#!/bin/bash
export AWS_BIN='$AWS_BIN'
export BACKUP_DIR='/home/$BACKUP_USER/backup_staging'
export BUCKET='$BUCKET'
ruby /usr/local/lib/s3_backup/s3_backup.rb
EOF
chmod 755 /usr/local/lib/s3_backup/s3_backup

sed "s/<<BACKUP_USER>>/$BACKUP_USER/g" s3-backup.service > /etc/systemd/system/s3-backup.service
cp s3-backup.timer /etc/systemd/system/
systemctl daemon-reload
systemctl start s3-backup.timer
systemctl enable s3-backup.timer
