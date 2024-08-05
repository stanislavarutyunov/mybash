#!/bin/bash

# Скрипт для сбора информации и проверки настроек указанной службы systemd

read -p "Введите название службы systemd: " service_name

if [[ -z "$service_name" ]]; then
    echo "Имя службы не может быть пустым. Пожалуйста, запустите скрипт заново и введите корректное имя службы."
    exit 1
fi

# Проверка того, что служба существует
if ! systemctl list-units --type=service --all | grep -q "$service_name"; then
    echo "Служба $service_name не найдена. Пожалуйста, проверьте название и запустите скрипт заново."
    exit 1
fi

# Сбор информации о службе
echo "Сбор информации о службе $service_name... "

# Статус службы
echo "== Статус службы =="
systemctl status "$service_name"

# Основные настройки службы
echo "== Конфигурация службы (unit-файл) =="
systemctl cat "$service_name" | cat

# Просмотр журнала службы
echo "== Логи службы =="
journalctl -u "$service_name" -n 50 --no-pager

# Проверка состояния и настроек службы
echo "== Проверка состояния службы =="
systemctl is-active "$service_name" && echo "Служба активна" || echo "Служба не активна"
systemctl is-enabled "$service_name" && echo "Служба включена для автозапуска" || echo "Служба не включена для автозапуска"

# Проверка PID службы
echo "== PID службы =="
pid=$(systemctl show -p MainPID --value "$service_name")
if [[ "$pid" -ne 0 ]]; then
    echo "PID службы: $pid"
else
    echo "PID не найден или служба не работает."
fi

# Проверка порта, на котором служба прослушивает соединения
echo "== Порт, прослушиваемый службой =="
if [[ "$pid" -ne 0 ]]; then
    ports=$(ss -tulnp | grep "$pid" | awk '{print $4}')
    if [[ -n "$ports" ]]; then
        echo "Служба прослушивает на следующих портах:"
        echo "$ports"
    else
        echo "Сервис не прослушивает порты или не найдено активных соединений для этого PID."
    fi
else
    echo "Невозможно определить порты без PID."
fi
# Показ завершенного сбора информации
echo "Сбор информации завершен."
