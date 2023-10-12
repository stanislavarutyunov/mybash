УСТАНОВКА ACL и ПРОВЕРКА:
#!/bin/bash

# Функция для установки прав
set_permissions() {
    file=$1
    permissions=$2
    owner=$3

    chmod $permissions $file
    chown $owner $file
}

# Установка прав для файлов
set_permissions /etc/passwd 644 root
set_permissions /etc/resolv.conf 644 root
set_permissions /etc/profile 644 root
set_permissions /etc/hosts 644 root
set_permissions /etc/services 644 root
set_permissions /etc/sysconfig/ 644 root
set_permissions /etc/ntp.conf 644 root

set_permissions /etc/shadow 600 root
set_permissions /etc/login.defs 600 root

set_permissions /etc/fstab 600 root
set_permissions /etc/crontab 600 root
set_permissions /etc/ssh/sshd_config 600 root

# Проверка прав и владельца
check_permissions() {
    file=$1
    permissions_expected=$2
    owner_expected=$3

    permissions=$(stat -c %a $file)
    owner=$(stat -c %U $file)

    if [ $permissions -ne $permissions_expected ]; then
        echo "Права файла $file не соответствуют ожидаемым правам ($permissions_expected)"
    fi

    if [ $owner != $owner_expected ]; then
        echo "Владелец файла $file не соответствует ожидаемому владельцу ($owner_expected)"
    fi
}

check_permissions /etc/passwd 644 root
check_permissions /etc/resolv.conf 644 root
check_permissions /etc/profile 644 root
check_permissions /etc/hosts 644 root
check_permissions /etc/services 644 root
check_permissions /etc/sysconfig/ 644 root
check_permissions /etc/ntp.conf 644 root

check_permissions /etc/shadow 600 root
check_permissions /etc/login.defs 600 root
check_permissions /etc/fstab 600 root
check_permissions /etc/crontab 600 root
check_permissions /etc/ssh/sshd_config 600 root
