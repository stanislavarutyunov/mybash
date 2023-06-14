#!/bin/bash
#rsyslog 
MP_IP_ADDRESS="10.192.64.164"
# 1. Создание файла и установка прав
sudo touch /etc/rsyslog.d/10-siem.conf
sudo chmod u=rw,g=r,o= /etc/rsyslog.d/10-siem.conf

# 2. Добавление правила отправки событий на узел MP10 Agent
sudo echo "*.info;local6.*;mail.none;lpr.none;news.none;uucp.none;cron.none @${MP_IP_ADDRESS}:514" >> /etc/rsyslog.d/10-siem.conf

# 3. Отключение сохранения событий службы auditd в файле /var/log/messages
sudo echo ":programname, contains, "audisp" stop" >> /etc/rsyslog.d/10-siem.conf

# 4. Раскомментирование строки $IncludeConfig в конфигурационном файле /etc/rsyslog.conf
sudo sed -i 's/#$IncludeConfig /$IncludeConfig /g' /etc/rsyslog.conf

# 5. Добавление строк в конфигурационный файл /etc/rsyslog.conf
sudo echo "$RepeatedMsgReduction off" >> /etc/rsyslog.conf
sudo echo "$imjournalRatelimitInterval 15" >> /etc/rsyslog.conf

# 6. Добавление строки в конфигурационный файл /etc/systemd/journald.conf
sudo sed -i 's/#RateLimitBurst= RateLimitBurst=/RateLimitBurst=20000/g' /etc/systemd/journald.conf

# Перезапуск сервиса rsyslog для применения изменений
sudo service rsyslog restart

echo "Конфигурация rsyslog успешно настроена!"
