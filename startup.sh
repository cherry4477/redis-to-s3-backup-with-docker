#!/bin/bash

# Test if the file exists
if [ -f /dump.rdb ]
then
    echo dump.rdb found
else
    echo dump.rdb not found. Check the path in the run command.
    exit 0
fi

date=`date +%Y-%m-%d`
prefix='dump-'
suffix='.rdb.tar.gz'
newname=$prefix$date$suffix

tar -zcvpf $newname dump.rdb

echo -e '
[default]
access_key = $AWS_ACCESS_KEY
access_token =
add_encoding_exts =
add_headers =
bucket_location = cn-north-1
cache_file =
cloudfront_host = cloudfront.amazonaws.com
default_mime_type = binary/octet-stream
delay_updates = False
delete_after = False
delete_after_fetch = False
delete_removed = False
dry_run = False
enable_multipart = True
encoding = ANSI_X3.4-1968
encrypt = False
expiry_date =
expiry_days =
expiry_prefix =
follow_symlinks = False
force = False
get_continue = False
gpg_command = /usr/bin/gpg
gpg_decrypt = %(gpg_command)s -d --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_encrypt = %(gpg_command)s -c --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_passphrase = $AWS_ENCRYPTION_PASSWORD
guess_mime_type = True
host_base = s3.amazonaws.com
host_bucket = %(bucket)s.s3.amazonaws.com
human_readable_sizes = False
ignore_failed_copy = False
invalidate_default_index_on_cf = False
invalidate_default_index_root_on_cf = True
invalidate_on_cf = False
list_md5 = False
log_target_prefix =
max_delete = -1
mime_type =
multipart_chunk_size_mb = 15
preserve_attrs = True
progress_meter = True
proxy_host =
proxy_port = 0
put_continue = False
recursive = False
recv_chunk = 4096
reduced_redundancy = False
restore_days = 1
secret_key = $AWS_SECRET_KEY
send_chunk = 4096
server_side_encryption = False
simpledb_host = sdb.amazonaws.com
skip_existing = False
socket_timeout = 300
urlencoding_mode = normal
use_https = False
use_mime_magic = True
verbosity = WARNING
website_endpoint = http://%(bucket)s.s3-website-%(location)s.amazonaws.com/
website_error =
website_index = index.html
' >> /root/.s3cfg

s3cmd put $newname s3://$DESTINATION/$newname

echo "Redis backup successful"
