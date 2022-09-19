#!/usr/bin/ruby

require "time"

aws_bin = ENV["AWS_BIN"]
bucket = ENV["BUCKET"]
backup_targets = {
    "/home/eva/passwords.enc" => "passwords.enc",
    "/home/eva/docs" => "docs",
    "/home/eva/img" => "img"
}

first_backoff_secs = 15
backoff_tries = 5

while backoff_tries > 0
    puts "Checking network..."
    network_check = `ping -c 1 archlinux.org 2>&1`

    if network_check =~ /1 received/
        break
    else
        sleep first_backoff_secs
        first_backoff_secs *= 2
        backoff_tries -= 1
    end
end

if backoff_tries == 0
    puts "Could not reach the internet. Giving up."
    exit 1
end

backup_targets.each do |local_path, bucket_path|
    if File.directory?(local_path)
        puts `#{aws_bin} s3 sync --delete #{local_path} s3://#{bucket}/#{bucket_path}`
    else
        puts `#{aws_bin} s3 cp #{local_path} s3://#{bucket}/#{bucket_path}`
    end
end

