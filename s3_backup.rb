#!/usr/bin/ruby

require "time"

aws_bin = ENV["AWS_BIN"]
backup_dir = ENV["BACKUP_DIR"]
bucket = ENV["BUCKET"]

s3_files = `#{aws_bin} s3 ls --recursive s3://#{bucket}/`
s3_files = s3_files.split("\n").map do |s| 
  out = s.split(/\s+/).map { |ss| ss.strip }
  modified_datetime = Time.strptime(
    "#{out[0]} #{out[1]}",
    "%Y-%m-%d %H:%M:%S"
  )

  [
    out[3..-1].join(" "),
    {
      :modified => modified_datetime.to_i,
      :size_bytes => out[2].to_i
    }
  ]
end.to_h

local_files = Dir.glob("#{backup_dir}/**{,/*/**}/*").uniq
local_files = local_files.select do |p|
  File.file?(p)
end.map do |p|
  [
    p.gsub("#{backup_dir}/", ""),
    {
      :modified => File.mtime(p).to_i
    }
  ]
end.to_h

s3_nonlocal_keys = s3_files.keys
local_files.each do |path, info|
  if s3_files.has_key?(path)
    s3_nonlocal_keys.delete(path)
    if info[:modified] > s3_files[path][:modified]
      puts `#{aws_bin} s3 cp '#{backup_dir}/#{path}' 's3://#{bucket}/#{path}'`.split("\r")[-1]
    end
  else
    s3_nonlocal_keys.delete(path)
    puts `#{aws_bin} s3 cp '#{backup_dir}/#{path}' 's3://#{bucket}/#{path}'`.split("\r")[-1]
  end
end

s3_nonlocal_keys.each do |path|
  puts `#{aws_bin} s3 rm 's3://#{bucket}/#{path}'`
end
