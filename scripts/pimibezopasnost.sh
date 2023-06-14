#!/usr/bin/env bash
# Записываем результаты выполнения команд в /tmp/logpmsh
exec > /tmp/logpmsh 2>&1 

# Запуск команд
astra-console-lock enable
passwd –l daemon
passwd –l bin
passwd –l mail
passwd –l news
passwd –l nobody
passwd –l lp
passwd –l uucp
usermod –s /sbin/nologin sshd
astra-nochmodx-lock enable
astra-ptrace-lock enable
mkiosk -u <stas
astra-ulimits-control enable
systemctl is-enabled
chmod 644 /etc/passwd
chmod 644 /etc/resolv.conf
chmod 644 /etc/profile
chmod 644 /etc/hosts
chmod 644 /etc/services
chmod 644 /etc/sysconfig/*
chmod 644 /etc/ntp.conf
chown root /etc/passwd
chown root /etc/resolv.conf
chown root /etc/profile
chown root /etc/hosts
chown root /etc/services
chown root /etc/sysconfig/*
chown root /etc/ntp.conf
chmod 600 /etc/shadow
chmod 600 /etc/login.defs
chmod 600 /etc/xinetd.conf
chmod 600 /etc/fstab
chmod 600 /etc/securetty
chmod 600 /etc/crontab
chmod 600 /etc/ssh/sshd_config
chown root /etc/shadow
chown root /etc/login.defs
chown root /etc/xinetd.conf
chown root /etc/fstab
chown root /etc/securetty
chown root /etc/crontab
chown root /etc/ssh/sshd_config
getent group wheel 
getent passwd 
getent group 
klist 
ps aux 
astra-ulimits-control enable
astra-console-lock enable 
systemctl is-enabled
netstat –ntulp 
find /usr/lib/python* -type f -name "_ctype*" 
sudo /opt/kaspersky/kesl/bin/kesl-control --app-info 
ssh 127.0.0.1 astra-admin
ausearch -f /etc/passwd | sudo aureport -f -i 
netstat –n 
rm -Rf /etc/sudoers.d/README
rm -Rf /etc/sudoers.d/zzz-parsec
sed -i 's/requisite pam_cracklib.so.*/requisite pam_cracklib.so ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1/' /etc/pam.d/common-password
sed -i 's/\(^auth\s\[success=ignore\)\(.*pam_tally\.so\)/\1 per_user deny=10 \2/' /etc/pam.d/common-auth
sed -i 's/password sufficient pam_unix.so.*/password sufficient pam_unix.so remember=24/' /etc/pam.d/common-password
sed -i 's/\(^auth\s\[success=ignore\)\(.*pam_tally\.so\)/\1 unlock_time=1800 \2/' /etc/pam.d/common-auth
sed -i s/"PASS_MIN_DAYS */PASS_MIN_DAYS 1/" /etc/login.defs
sed -i s/"PASS_WARN_AGE */PASS_WARN_AGE 14/" /etc/login.defs
sed -i s/"LOGIN_RETRIES */LOGIN_RETRIES 10/" /etc/login.defs
sed -i s/"LOGIN_TIMEOUT */LOGIN_TIMEOUT 1800/" /etc/login.defs
sed -i s/#"PermitRootLogin_prohibit-password/PermitRootLogin no" /etc/ssh/sshd_config 
sed -i s/#"kernel.sysrq=1/kernel.sysrq=0" /etc/sysctl.conf 
sed -i s/#"auth required pam_wheel.so/auth required pam_wheel.so" /etc/pam.d/su
sed '1s!/bin/bash!/usr/sbin/nologin!' /etc/passwd
sed -i s/"password requisite pam_cracklib.so*/password requisite pam_cracklib.so retry=10 minlen=32 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1 enforce_for_root reject_username" /etc/pam.d/common-password
echo -n > /etc/securetty
echo -n "username map = /etc/sudoers" >>/etc/samba/smb.conf
cat /etc/rsyslog.d/remote.conf 
cat /etc/logrotate.d/rsyslog 
cat /var/log/auth.log | grep stas
cat getfacl /var/log/audit/audit.log 
cat /etc/sudoers | grep include
lsblk –f
ls -al /