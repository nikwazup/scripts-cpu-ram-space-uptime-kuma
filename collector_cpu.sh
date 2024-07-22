#!/bin/bash

while true; do
  # Собираем статистику по CPU за минуту и записываем в файл
  mpstat 1 300 > cpu_usage_5_min.txt

  # Вычисляем общую загрузку CPU из последней строки файла
  cpu_usage=$(awk 'END { usr=$3; sys=$5; iowait=$7; soft=$9; total = usr + sys + iowait + soft; print total }' cpu_usage_5_min.txt)
echo "CPU Usage: $cpu_usage%"


  # Проверяем уровень загрузки CPU и отправляем соответствующий запрос
  if (( $(echo "$cpu_usage < 80" | bc -l) )); then
    curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=up&msg=${cpu_usage}%20CPU_working_good&ping=$cpu_usage"
  else
    curl "https://mids-uptime.web-lightnings.ru/api/push/$push_key?status=down&msg=${cpu_usage}%20CPU_overload&ping=$cpu_usage"
  fi

  # Пауза перед следующим циклом (60 секунд уже затрачены на mpstat)
  sleep 1
done
