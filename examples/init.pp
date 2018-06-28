# @PDQTest
class { "rsyslog_client":
  settings => [
    {'$FileOwner'      => 'root'},
    {'$FileGroup'      => 'root'},
    {'$FileCreateMode' => '0600'},
    {'$DirOwner'       => 'root'},
    {'$DirGroup'       => 'root'},
    {'$DirCreateMode'  => '0750'},
  ],
  entries => {
    "auth,user.*"                                                      => "/var/log/messages",
    "kern.*"                                                           => "/var/log/kern.log",
    "daemon.*"                                                         => "/var/log/daemon.log",
    "syslog.*"                                                         => "/var/log/syslog",
    "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" => "/var/log/unused.log",
  }
}