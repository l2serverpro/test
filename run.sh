#!/bin/bash

# Проверяем, передано ли количество GPU как аргумент командной строки
if [ $# -eq 0 ]; then
    echo "Usage: $0 <number_of_gpu>"
    exit 1
fi

# Запускаем цикл для каждой GPU
for ((i=0; i<$1; i++)); do
  node send_universal.js --api tonhub --bin ./pow-miner-cuda --gpu $i &
done

# Ожидаем завершения всех процессов
wait