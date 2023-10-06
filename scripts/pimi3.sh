#!/bin/bash

#Проверка формата записи аудита в /var/log/audit/audit.log

log_file="/var/log/audit/audit.log"

if [ ! -f $log_file ]; then
  echo "Log file not found"
  exit 1
fi

awk -F ";" '{print "Date and Time: " $1 "\nUser ID: " $2 "\nResult: " $3 "\n"}' $log_file

# Проверка,что логи хранятся три месяца

log_file="/var/log/audit/audit.log"

if [ ! -f $log_file ]; then
  echo "Audit log file not found"
  exit 1
fi

# Задаем переменную 3 месяца назад
three_months_ago=$(date -d "3 months ago" +"%s")

# Переменная последнее изменение логов
last_modified=$(stat -c %Y $log_file)

if [ $last_modified -lt $three_months_ago ]; then
  echo "Audit log file is older than three months"
else
  echo "Audit log file is within the last three months"
fi