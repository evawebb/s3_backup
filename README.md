# s3_backup

## Setup

Run `sudo AWS_BIN="$(which aws)" BACKUP_USER=[your_username] BUCKET=[your_bucket] ./install.sh`. This will copy the backup script into `/usr/local/lib/s3_backup/`, then will install, enable, and start the timer service.

Create a `/home/[your_username]/backup_staging/` directory. The service will back up any files in this directory to S3 weekly. You can either actually put the files in this directory, or use symlinks.

## Uninstalling

Just run `sudo ./uninstall.sh`, and it will delete `/usr/local/lib/s3_backup` and the two systemd units.
