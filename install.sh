#!/bin/bash
set -ex

mkdir /usr/local/lib/s3_backup || true
cp s3_backup.rb /usr/local/lib/s3_backup/
cp s3-backup.service /etc/systemd/system/
cp s3-backup.timer /etc/systemd/system/
systemctl daemon-reload
systemctl start s3-backup.timer
systemctl enable s3-backup.timer
