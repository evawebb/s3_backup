#!/bin/bash
systemctl stop s3-backup.timer
systemctl disable s3-backup.timer
rm -rvf /usr/local/lib/s3_backup
rm -rvf /etc/systemd/system/s3-backup.timer
rm -rvf /etc/systemd/system/s3-backup.service
