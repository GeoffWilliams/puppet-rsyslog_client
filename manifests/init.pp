# @summary Support for installation and configuration of rsyslog.
#
# Support for installation and configuration of rsyslog. We support the bare minimum needed to
# enable support on RHEL7, eg all legacy config/no rainer script. This is inline with the
# default `rsyslog.conf` file installed by the vendor.
#
# @example Install and enable rsyslog
#   include rsyslog_client
#
# @example Hiera data for general rsyslog settings
#   rsyslog_client::settings:
#     - '$FileOwner': 'root'
#     - '$FileGroup': 'root'
#     - '$FileCreateMode': '0600'
#     - '$DirOwner': 'root'
#     - '$DirGroup': 'root'
#     - '$DirCreateMode': '0750'
#
# @example Hiera data for rsyslog entries
#   rsyslog_client::entries:
#     'daemon.*': /var/log/daemon.log
#     'syslog.*': /var/log/syslog
#
# @param service Name of rsyslog service to manage
# @param service_ensure Ensure the service to this value
# @param service_enable Enable the service at boot?
# @param settings Settings to insert into the `rsyslog.conf` file. Existing definitions will be
#   replaced in-place. If a setting is added that doesn't already exist, it will be inserted
#   into the file _from_ line `setting_insertion_line`. Settings will be processed in array
#   order (see examples)
# @param entries Hash of logging entries to create (see examples)
# @param config_file configuration file to write
# @param settings_insertion_line If a setting needs to be inserted, insert starting at this line
#   (zero indexed)
class rsyslog_client(
    String                    $package                  = "rsyslog",
    String                    $service                  = "rsyslog",
    Enum['running','stopped'] $service_ensure           = "running",
    Boolean                   $service_enable           = true,
    Array[Hash[String,Any]]   $settings                 = [],
    Hash[String,Any]          $entries                  = {},
    String                    $config_file              = "/etc/rsyslog.conf",
    Integer                   $settings_insertion_line  = 23,
) {

  package { $package:
    ensure => installed,
  }

  service { $service:
    ensure => $service_ensure,
    enable => $service_enable,
  }

  $settings.each |$setting| {
    $setting.each |$key, $value| {
      # all setting names start with '$' so we must escape it to handle it as a string literal
      fm_replace { "${config_file}:${key}":
        ensure            => present,
        path              => $config_file,
        data              => "${key} ${value}",
        match             => "\\${key}",
        insert_if_missing => true,
        insert_at         => $settings_insertion_line,
        notify            => Service[$service],
      }
    }
  }


  $entries.each |$key, $value| {
    fm_replace { "${config_file}:${key}":
      ensure            => present,
      path              => $config_file,
      data              => "${key} ${value}",
      match             => "^(${key}|${value})",
      insert_if_missing => true,
      insert_at         => 'bottom',
      notify            => Service[$service],
    }
  }
}