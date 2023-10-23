#!/bin/bash

files=(
    '/etc/passwd|644|root'
    '/etc/resolv.conf|644|root'
    '/etc/profile|644|root'
    '/etc/hosts|644|root'
    '/etc/services|644|root'
    '/etc/sysconfig/|644|root'
    '/etc/ntp.conf|644|root'
    '/etc/shadow|600|root'
    '/etc/login.defs|600|root'
    '/etc/fstab|600|root'
    '/etc/crontab|600|root'
    '/etc/ssh/sshd_config|600|root'
)

# Функция для установки прав
set_permissions() {
    file=$1
    permissions=$2
    owner=$3

    chmod $permissions $file
    chown $owner $file
}

# Проверка прав и владельца
check_permissions() {
    file=$1
    permissions_expected=$2
    owner_expected=$3

    permissions=$(stat -c %a $file)
    owner=$(stat -c %U $file)

    if [ $permissions -ne $permissions_expected ]; then
        echo "Права файла $file не соответствуют ожидаемым правам ($permissions_expected)"
        return 100
    fi

    if [ $owner != $owner_expected ]; then
        echo "Владелец файла $file не соответствует ожидаемому владельцу ($owner_expected)"
        return 100
    fi
}

for fields in "$(files[@])"
do 
    IFS='|' read file perm usr <<< "$fields"
    check_permissions $file $perm $usr
    if [ $? -eq "100" ]; then
        echo "Устанавливаю корректные права $perm и владельца $usr на файл $file"
        set_permissions $file $perm $usr
    fi
done