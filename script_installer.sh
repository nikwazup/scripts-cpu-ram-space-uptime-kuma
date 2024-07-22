#!/bin/bash

echo "Выберите скрипт для выполнения:"
echo "1. CPU"
echo "2. RAM"
echo "3. Space"
read -p "Введите номер выбора: " choice

read -p "Введите IP сервера: " ips
read -p "Введите порт: " port
read -p "Введите push key: " push_key
read -p "Введите имя пользователя: " username

case $choice in
  1) 
    scp -P $port /home/devops/Desktop/reports_mids/health_cheaclks2/collector_cpu.sh $username@$ips:/home/$username/collector_$choice.sh
    ssh -p $port $username@$ips "sudo sed -i 's/\$push_key/$push_key/g' /home/$username/collector_$choice.sh"
    scp -P $port /home/devops/Desktop/reports_mids/health_cheaclks2/service_file $username@$ips:/home/$username/collector_$choice.service
    ssh -p $port $username@$ips "sudo sed -i 's/\$choice/$choice/g' /home/$username/collector_$choice.service"
    ssh -p $port $username@$ips "sudo sed -i 's/\$username/$username/g' /home/$username/collector_$choice.service"
    ssh -p $port $username@$ips "sudo mv /home/$username/collector_$choice.service /etc/systemd/system/collector_$choice.service"
    ssh -p $port $username@$ips "sudo systemctl daemon-reload && sudo systemctl start collector_$choice.service && sudo systemctl enable collector_$choice.service"
    ;;
  2)
    scp -P $port /home/devops/Desktop/reports_mids/health_cheaclks2/collector_ram.sh $username@$ips:/home/$username/collector_$choice.sh
    ssh -p $port $username@$ips "sudo sed -i 's/\$push_key/$push_key/g' /home/$username/collector_$choice.sh"
    scp -P $port /home/devops/Desktop/reports_mids/health_cheaclks2/service_file $username@$ips:/home/$username/collector_$choice.service
    ssh -p $port $username@$ips "sudo sed -i 's/\$username/$username/g' /home/$username/collector_$choice.service"
    ssh -p $port $username@$ips "sudo sed -i 's/\$choice/$choice/g' /home/$username/collector_$choice.service"
    ssh -p $port $username@$ips "sudo mv /home/$username/collector_$choice.service /etc/systemd/system/collector_$choice.service"
    ssh -p $port $username@$ips "sudo systemctl daemon-reload && sudo systemctl start collector_$choice.service && sudo systemctl enable collector_$choice.service"
    ;;
  3)
    scp -P $port /home/devops/Desktop/reports_mids/health_cheaclks2/collector_space.sh $username@$ips:/home/$username/collector_$choice.sh
    ssh -p $port $username@$ips "sudo sed -i 's/\$push_key/$push_key/g' /home/$username/collector_$choice.sh"
    scp -P $port /home/devops/Desktop/reports_mids/health_cheaclks2/service_file $username@$ips:/home/$username/collector_$choice.service
    ssh -p $port $username@$ips "sudo sed -i 's/\$username/$username/g' /home/$username/collector_$choice.service"
    ssh -p $port $username@$ips "sudo sed -i 's/\$choice/$choice/g' /home/$username/collector_$choice.service"
    ssh -p $port $username@$ips "sudo mv /home/$username/collector_$choice.service /etc/systemd/system/collector_$choice.service"
    ssh -p $port $username@$ips "sudo systemctl daemon-reload && sudo systemctl start collector_$choice.service && sudo systemctl enable collector_$choice.service"
    ;;
  *)
    echo "Неверный выбор"
    exit 1
    ;;
esac

# Установка необходимых пакетов
ssh -p $port $username@$ips "sudo apt install bc -y && sudo apt install sysstat -y"
