#!/bin/bash

# Отправляем уведомление о запуске скрипта
curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=up&msg=%F0%9F%9A%80%20RAM%20bot_started"

# Предыдущее состояние использования RAM (0 - норма, 1 - использовано более 80%)
previous_state=0

while true; do
    # Получаем процент использования памяти
    total=$(free -m | grep Mem: | awk '{print $2}')
    used=$(free -m | grep Mem: | awk '{print $3}')
    free_ram=$(echo "scale=2; $used/$total*100" | bc)

    # Проверяем, превышает ли использование 80%
    if (( $(echo "$free_ram > 80" | bc -l) )); then
        # Если RAM больше 80%
        if [ $previous_state -eq 0 ]; then
            previous_state=1
        fi
        curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=down&msg=RAM_overload_${free_ram}&ping=$free_ram"
    else
        # Если RAM меньше 80%
        if [ $previous_state -eq 1 ]; then
            previous_state=0
        fi
        curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=up&msg=RAM%20feels%20better_${free_ram}&ping=free_ram"
    fi

    # Пауза 20 секунд перед следующей проверкой
    sleep 20
done

