# Set up a repository for foreman
define foreman::repos(
  $repo = stable,
  $gpgcheck = true
) {
  include ::foreman::params

  case $::osfamily {
    'RedHat': {
      foreman::repos::yum {$name:
        repo     => $repo,
        yumcode  => $::foreman::params::yumcode,
        gpgcheck => $gpgcheck,
      }
    }
    'Debian': {
      # If OS is xenial, or OS is bionic & on the 1.x Foreman branch, use the archivedeb repo
      if $facts['os']['lsb']['distcodename'] == 'xenial' or ($facts['os']['lsb']['distcodename'] and 'bionic' && (versioncmp($repo, 2.0) == -1)) {
        foreman::repos::apt {$name:
          repo     => $repo,
          key      => '5B7C3E5A735BCB4D615829DC0BDDA991FD7AAC8A',
          location => 'https://archivedeb.theforeman.org/',
        }
      } else  {
        foreman::repos::apt {$name:
          repo => $repo,
        }
      }
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          foreman::repos::yum {$name:
            repo     => $repo,
            yumcode  => $::foreman::params::yumcode,
            gpgcheck => $gpgcheck,
          }
        }
        default: {
          fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }
}
