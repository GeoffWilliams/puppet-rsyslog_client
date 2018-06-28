@test "FileOwner set in config file" {
    grep "FileOwner root" /etc/rsyslog.conf
}

@test "FileGroup set in config file" {
    grep "FileGroup root" /etc/rsyslog.conf
}

@test "FileCreateMode set in config file" {
    grep "FileCreateMode 0600" /etc/rsyslog.conf
}

@test "DirOwner set in config file" {
    grep "DirOwner root" /etc/rsyslog.conf
}
@test "DirGroup set in config file" {
    grep "DirGroup root" /etc/rsyslog.conf
}

@test "DirCreateMode set in config file" {
    grep "DirCreateMode 0750" /etc/rsyslog.conf
}

@test "service running" {
    systemctl status rsyslog
}