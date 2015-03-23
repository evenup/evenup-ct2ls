# == Class: ct2ls
#
# This class installs and configures ct2ls
#
#
# === Parameters
#
# [*install_gems*]
#   Boolean.  Whether or not gem dependencies should be managed
#   Default: false
#
# [*gem_provider*]
#   String.  Provider for managed gems to be installed iwth
#   Default: gem
#
# [*dependency_gems*]
#   Array of Strings.  List of dependencies to install.  Placed here to ease changing gem names for different providers
#   Default: [ 'aws-sdk', 'redis', 'daemons' ],
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
class ct2ls (
  $access_key_id,
  $secret_access_key,
  $install_gems    = false,
  $gem_provider    = 'gem',
  $dependency_gems = [ 'aws-sdk', 'redis', 'daemons' ],
  $sqs_queue       = 'cloudtrail',
  $redis_host      = 'localhost',
  $redis_port      = 6379,
  $redis_db        = 0,
  $redis_list      = 'logstash:cloudtrail',
  $tmp_path        = '/tmp',
  $remove_original = true,
  $logpath         = '/var/log/ct2ls',
  $log_level       = 'INFO',
) {

  validate_bool($install_gems)

  class { 'ct2ls::install': } ->
  class { 'ct2ls::config': } ~>
  class { 'ct2ls::service': }
  Class['ct2ls::install'] ~> Class['ct2ls::service']


}
