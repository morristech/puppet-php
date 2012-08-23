define php::conf($ensure = present, $source = undef, $content = undef, $require = undef, $notify = undef) {
    include php

    $file_name = "${name}.ini"

    # Puppet will bail out if both source and content is set,
    # hence we don't have to deal with it.
    file { $file_name:
        path    => "${php::params::conf_dir}${file_name}",
        mode    => 644,
        owner   => root,
        group   => root,
        ensure  => $ensure,
        notify  => $notify,
        require => $require ? {
            undef   => Class['php'],
            default => [ Class['php'], $require, ],
        },
        source  => $source ? {
            undef   => undef,
            true    => [
                "puppet:///modules/php/${fqdn}/etc/php5/conf.d/${file_name}",
                "puppet:///modules/php/${hostgroup}/etc/php5/conf.d/${file_name}",
                "puppet:///modules/php/${domain}/etc/php5/conf.d/${file_name}",
                "puppet:///modules/php/global/etc/php5/conf.d/${file_name}",
            ],
            default => "${source}${file_name}",
        },
        content => $content ? {
            undef   => undef,
            default => template("${content}${file_name}.erb"),
        },
    }
}
