# == Class: ct2ls::config
#
# This class configures ct2ls
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
class ct2ls::config {

  file { '/etc/ct2ls.yaml':
    ensure  => 'file',
    mode    => '0440',
    owner   => 'ct2ls',
    group   => 'ct2ls',
    notify  => Class['ct2ls::service'],
    content => template('ct2ls/ct2ls.yaml.erb'),
  }

}
