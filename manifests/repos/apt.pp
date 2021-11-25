# Install an apt repo
define foreman::repos::apt (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  Optional[String] $key = 'AE0AF310E2EA96B6B6F4BD726F8600B9563278F6',
  Optional[Stdlib::HTTPUrl] $location = 'https://deb.theforeman.org/',
) {

  include ::apt

  Apt::Source {
    location => $location,
    key      => $key,
    include  => {
      src => false,
    },
  }

  ::apt::source { $name:
    repos => $repo,
  }

  ::apt::source { "${name}-plugins":
    release => 'plugins',
    repos   => $repo,
  }

}
