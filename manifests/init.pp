# == Class: ct2ls
#
# This class installs and configures ct2ls
#
#
# === Parameters
#
# [*access_key_id*]
#   String.  AWS Access Key
#
# [*secret_access_key*]
#   String.  AWS Secret Key
#
# [*sqs_queue*]
#   String.  Queue CloudTrail notifications are in
#   Default: cloudtrail
#
# [*redis_host*]
#   String.  Redis host
#   Default: localhost
#
# [*redis_port*]
#   Integer.  Redis port
#   Default: 6379
#
# [*redis_db*]
#   Integer.  Redis database
#   Default: 0
#
# [*tmp_path*]
#   String.  Path to use for temporary file storage
#   Default: /tmp
#
# [*remove_original*]
#   Boolean.  Should log files be removed from S3?
#   Default: true
#
# [*logpath*]
#   String.  Logfile for st2ls
#   Default: /var/log/ct2ls
#
# [*log_level*]
#   String.  Log level for logging
#   Default: INFO
#
#
# === Examples
#
# * Installation:
#     class { 'ct2ls':
#       access_key_id     => 'ABCDE',
#       secret_access_key => '12345',
#     }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2014 EvenUp.
#
class ct2ls (
  $access_key_id,
  $secret_access_key,
  $sqs_queue          = 'cloudtrail',
  $redis_host         = 'localhost',
  $redis_port         = 6379,
  $redis_db           = 0,
  $tmp_path           = '/tmp',
  $remove_original    = true,
  $logpath            = '/var/log/ct2ls',
  $log_level          = 'INFO',
) {

  include ruby::aws_sdk
  include ruby::redis
  include ruby::daemons

#  anchor { 'ct2ls::begin': } ->
  class { 'ct2ls::install': } ->
  class { 'ct2ls::config': } ->
  class { 'ct2ls::service': }
#  anchor { 'ct2ls::end': }

}
