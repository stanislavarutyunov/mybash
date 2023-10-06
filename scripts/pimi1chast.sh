#!/bin/bash

# Проверка домена в файле /etc/krb5.conf
if grep "stas" /etc/krb5.conf >/dev/null; then
  echo "В файле /etc/krb5.conf указан домен stas."
else
  echo "В файле /etc/krb5.conf не указан домен stas. Исправление..."
  sed -i 's/^\(default_realm\).*$/\1 = stas/g' /etc/krb5.conf
fi


# Проверка домена контроллеров в файле /etc/hosts
expected_hosts=("stas-dc1" "stas-dc2" "stas-dc3")
actual_hosts=$(grep "stas-dc" /etc/hosts | awk '{print $2}')
if [[ "$expected_hosts" == "$actual_hosts" ]]; then
  echo "В файле /etc/hosts указаны домены контроллеров."
else
  echo "В файле /etc/hosts не указаны верные домены контроллеров. Исправление..."
  sed -i '/stas-dc/d' /etc/hosts
  for host in "${expected_hosts[@]}"; do
    echo -e "127.0.0.1\t$host" >> /etc/hosts
  done
fi

# Проверка настроек в файле /etc/sssd/sssd.conf
if grep "ad_domain = uib.net" /etc/sssd/sssd.conf >/dev/null && \
   grep "ad_server = stas-dc1" /etc/sssd/sssd.conf >/dev/null && \
   grep "krb5_realm = uib.net" /etc/sssd/sssd.conf >/dev/null; then
  echo "В файле /etc/sssd/sssd.conf указаны верные настройки."
else
  echo "В файле /etc/sssd/sssd.conf не указаны верные настройки. Исправление..."
  sed -i '/ad_domain/d' /etc/sssd/sssd.conf
  sed -i '/ad_server/d' /etc/sssd/sssd.conf
  sed -i '/krb5_realm/d' /etc/sssd/sssd.conf
  echo "ad_domain = uib.net" >> /etc/sssd/sssd.conf
  echo "ad_server = stas-dc1" >> /etc/sssd/sssd.conf
  echo "krb5_realm = uib.net" >> /etc/sssd/sssd.conf
fi


# Проверка хранения хэш-сверток паролей в файле /etc/shadow
if grep "^\$6" /etc/shadow >/dev/null; then
  echo "В файле /etc/shadow хранятся хэш-свертки паролей."
else
  echo "В файле /etc/shadow не хранятся хэш-свертки паролей. Исправление..."
  sed -i 's/^\(PASSWD_ALGORITHM\).*$/\1\tsalted sha512/g' /etc/login.defs
fi
 

# Проверка настроек в файле /etc/security/pwquality.conf
if grep "retry = 10" /etc/security/pwquality.conf >/dev/null && \
   grep "minlen = 15" /etc/security/pwquality.conf >/dev/null && \
   grep "lcredit = -1" /etc/security/pwquality.conf >/dev/null && \
   grep "ucredit = -1" /etc/security/pwquality.conf >/dev/null && \
   grep "dcredit = -1" /etc/security/pwquality.conf >/dev/null && \
   grep "ocredit = -1" /etc/security/pwquality.conf >/dev/null && \
   grep "enforce_for_root" /etc/security/pwquality.conf >/dev/null && \
   grep "reject_username" /etc/security/pwquality.conf >/dev/null; then
  echo "В файле /etc/security/pwquality.conf указаны верные параметры."
else
  echo "В файле /etc/security/pwquality.conf не указаны верные параметры. Исправление..."
  sed -i 's/^retry.*$/retry = 10/g' /etc/security/pwquality.conf
  sed -i 's/^minlen.*$/minlen = 15/g' /etc/security/pwquality.conf
  sed -i 's/^lcredit.*$/lcredit = -1/g' /etc/security/pwquality.conf
  sed -i 's/^ucredit.*$/ucredit = -1/g' /etc/security/pwquality.conf
  sed -i 's/^dcredit.*$/dcredit = -1/g' /etc/security/pwquality.conf
  sed -i 's/^ocredit.*$/ocredit = -1/g' /etc/security/pwquality.conf
  sed -i '/enforce_for_root/d' /etc/security/pwquality.conf
  echo "enforce_for_root" >> /etc/security/pwquality.conf
  sed -i '/reject_username/d' /etc/security/pwquality.conf
  echo "reject_username" >> /etc/security/pwquality.conf
fi
 

 #Проверка настроек в файле /etc/login.defs

 if grep "^PASS_MIN_DAYS\s1$" /etc/login.defs >/dev/null && \
   grep "^PASS_WARN_AGE\s7$" /etc/login.defs >/dev/null && \
   grep "^LOGIN_RETRIES\s10$" /etc/login.defs >/dev/null && \
   grep "^LOGIN_TIMEOUT\s1800$" /etc/login.defs >/dev/null; then
  echo "В файле /etc/login.defs указаны верные параметры."
else
  echo "В файле /etc/login.defs не указаны верные параметры. Исправление..."
  sed -i 's/^\(PASS_MIN_DAYS\).*$/\1\t1/g' /etc/login.defs
  sed -i 's/^\(PASS_WARN_AGE\).*$/\1\t7/g' /etc/login.defs
  sed -i 's/^\(LOGIN_RETRIES\).*$/\1 = 10/g' /etc/login.defs
  sed -i 's/^\(LOGIN_TIMEOUT\).*$/\1 = 1800/g' /etc/login.defs
fi

# Проверка настроек в файле /etc/pam.d/common-password
if grep "password\srequired\spam_pwhistory.so\sremember=24" /etc/pam.d/common-password >/dev/null; then
  echo "В файле /etc/pam.d/common-password указаны верные значения."
else
  echo "В файле /etc/pam.d/common-password не указаны верные значения. Исправление..."
  sed -i 's/^password\srequired\spam_pwhistory.so.*/password required pam_pwhistory.so remember=24/g' /etc/pam.d/common-password
fi
 


 # Проверка настроек в файле /etc/pam.d/su
su_active=$(grep -c "^auth required pam_wheel.so$" /etc/pam.d/su)
if [ $su_active -eq 0 ]; then
  echo "auth required pam_wheel.so is not active in /etc/pam.d/su"
  sed -i 's/^#auth required pam_wheel.so$/auth required pam_wheel.so/g' /etc/pam.d/su
fi

# Проверка настроек группы wheel
wheel_users=("root" "mqm" "mqbrkrs" "hacluster")
for user in "${wheel_users[@]}"; do
  user_in_wheel=$(grep -c "^$user:" /etc/group)
  if [ $user_in_wheel -ne 0 ]; then
    echo "User $user should not be in the wheel group"
    sed -i "s/^wheel:x:.*:/$user:x:/" /etc/group
  fi
done


# Проверка include в sudoers
 sudoers_include_active=$(grep -c "^# include \/etc\/sudoers.d$" /etc/sudoers)
if [ $sudoers_include_active -ne 0 ]; then
  echo "Include directive is active in /etc/sudoers"
  sed -i 's/^# include \/etc\/sudoers.d$/#include \/etc\/sudoers.d/' /etc/sudoers
fi




# Проверка настроек в файле /etc/ssh/sshd_config (PermitRootLogin no)
 permit_root_login_active=$(grep -c "^PermitRootLogin no$" /etc/ssh/sshd_config)
if [ $permit_root_login_active -eq 0 ]; then
  echo "PermitRootLogin no is not specified in /etc/ssh/sshd_config"
  sed -i 's/^#PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config
fi


#Проверка /etc/securetty(убедиться,что файл пуст)
# securetty_size=$(wc -c < /etc/securetty)
#if [ $securetty_size -ne 0 ]; then
#  echo "/etc/securetty is not empty"
#  echo -n > /etc/securetty
#fi

# Проверка вывода команды ss –n | tail -30
if ss -n | tail -30 | grep -E "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|[a-zA-Z0-9]+.[a-zA-Z0-9]+.[a-zA-Z0-9]+.[a-zA-Z0-9]+"; then
    echo "Успешная проверка подключений с указанием IP-адресов или DNS-имен хостов."
else
    echo "Ошибка при проверке подключений с указанием IP-адресов или DNS-имен хостов."
fi


# Проверка вывода команды sudo fdisk -l
if sudo fdisk -l | grep -E "Disk \/dev\/.*:|\/dev\/.*:"; then
    echo "Успешная проверка текущей разметки диска с указанием имен разделов и их границ."
else
    echo "Ошибка при проверке текущей разметки диска с указанием имен разделов и их границ."
fi



# Проверка вывода команды ls -al /
if ls -al / | grep -E "^[d-]"; then
    echo "Успешная проверка имен каталогов и файлов с указанием их размера, прав доступа и даты изменения."
else
    echo "Ошибка при проверке имен каталогов и файлов с указанием их размера, прав доступа и даты изменения."
fi


#Проверка вывода команды ps ef | more
if ps ef | more | grep -E "^[a-zA-Z0-9]+\s+[0-9]+\s+[0-9]+\s+[0-9]+\s+[a-zA-Z0-9]+\s+\/.*"; then
    echo "Успешная проверка контроля доступа субъектов к защищаемым ресурсам."
else
    echo "Ошибка при проверке контроля доступа субъектов к защищаемым ресурсам."
fi 
