#!/bin/bash

# Убедимся, что скрипт запускается с правами суперпользователя
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен запускаться с правами суперпользователя. Пожалуйста, используйте 'sudo'."
    exit 1
fi

# Запись искомой строки
search_term="openvpn-monitor"

# Лог-файл для хранения результатов
output_file="/var/log/search_result.log"

# Очистка лог-файла перед началом поиска
> "$output_file"

echo "Поиск строки '$search_term' во всех файлах системы..."

# Используем find для поиска всех файлов и передаем их в grep для поиска строки
find / -type f 2>/dev/null | grep -v -e "^/proc" -e "^/sys" -e "^/dev" | xargs -d '\n' grep -IHn "$search_term" >> "$output_file" 2>/dev/null

echo "Поиск завершен. Результаты записаны в файл $output_file"
