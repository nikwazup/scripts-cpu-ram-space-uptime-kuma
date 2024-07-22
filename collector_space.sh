#!/bin/bash

# Отправляем уведомление о запуске скрипта
curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=up&msg=%F0%9F%9A%80%20SPACE%20monitoring%20bot%20started!"

# Предыдущее состояние использования диска (0 - свободно больше 80%, 1 - свободно меньше 80%)
previous_state=0

while true; do
    # Получаем процент свободного дискового пространства для корневого раздела
    # Вывод df -h, затем извлекаем строку с корнем, получаем 5-й столбец, который показывает использованное пространство, удаляем '%'
    used_space=$(df -h / | grep -v Filesystem | awk '{print $5}' | sed 's/%//g')

    # Проверяем, не превышает ли использованное пространство 80%
    if (( used_space > 80 )); then
        # Использованное пространство больше 80%
        if [ $previous_state -eq 0 ]; then
            previous_state=1
        fi
        curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=down&msg=Space_memory_overload_at_$used_space%&ping=$used_space"
    else
        # Использованное пространство меньше 80%
        if [ $previous_state -eq 1 ]; then
            previous_state=0
        fi
        curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=up&msg=Space_memory_feels_good_$used_space%&ping=$used_space"
    fi

    # Пауза 20 секунд перед следующей проверкой
    sleep 20
done
