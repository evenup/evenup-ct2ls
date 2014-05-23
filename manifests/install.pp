# == Class: ct2ls::install
#
# This class installs ct2ls
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
class ct2ls::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  user { 'ct2ls':
    ensure  => present,
    system  => true,
    gid     => 'ct2ls',
    shell   => '/sbin/nologin',
    home    => '/usr/share/ct2ls';
  }

  group { 'ct2ls':
    ensure  => present,
    system  => true;
  }

  File {
    owner   => 'ct2ls',
    group   => 'ct2ls',
    notify  => Class['ct2ls::service'],
  }

  file { '/usr/share/ct2ls':
    ensure  => 'directory',
    mode    => '0555',
  }

  file { '/usr/share/ct2ls/ct2ls.rb':
    mode    => '0554',
    source  => 'puppet:///modules/ct2ls/ct2ls.rb',
    notify  => Class['ct2ls::service'],
  }

  file { '/etc/init.d/ct2ls':
    mode    => '0555',
    source  => 'puppet:///modules/ct2ls/ct2ls.init',
  }

  file { '/var/run/ct2ls':
    ensure  => 'directory',
    mode    => '0775',
  }

  file { $ct2ls::logpath:
    ensure  => 'directory',
    mode    => '0775'
  }
}
