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
class ct2ls::service {

  service { 'ct2ls':
    ensure  => 'running',
    enable  => 'true',
  }

}
