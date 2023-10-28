#!/bin/bash

# Set up variables
MAIN_MINER="/hive/miners/onezerominer/1.2.5/onezerominer"
ZIL_MINER="/hive/miners/custom/quai_custom"
MAIN_POOL=none"
ZIL_POOL="stratum+tcp://eu.crazypool.org:5005"
MAIN_WALLET="none"
ZIL_WALLET="zil1a5q5amvpx48s97hac2wx6jrsu7ea0g6fvyrnsu"
#GPU_ID="0"

# Start Zilliqa mining
echo "Start Zilliqa mining + MAIN mining"
nohup $ZIL_MINER  -a zil --zil-cache-dag off -o $ZIL_POOL -u $ZIL_WALLET --zil-countdown -p x -w test > rigel.log 2>&1 &
#nohup $MAIN_MINER  -G -L 0 --HWMON 1 -P stratum://89.169.41.217:3333
#miner start

nvtool --setcoreoffset 150 --setmem 0 --setclocks 1485 --setmemoffset -400

# Wait for Zilliqa mining to start
echo "Wait for Zilliqa mining to start"
while true; do
  if pgrep -f $ZIL_MINER > /dev/null; then
    echo "Zilliqa mining has started"
    break
  else
    echo "ZIL miner not found"
  fi
  sleep 1
done

# Monitor rigel.log for Zilliqa session started/finished messages
tail -f rigel.log | while read line; do
  if [[ $line == *"Zilliqa session started"* ]]; then
    echo "Zilliqa mining started, stopping MAIN"

    # Set the memory clock up speed down gpu clock speed
    nvtool --setcoreoffset 100 --setmem 0 --setclocks 0 –setmemoffset 800

miner stop
#    pkill -f "$MAIN_MINER"
  elif [[ $line == *"Zilliqa session finished"* ]]; then
    echo "Zilliqa mining finished, starting MAIN"

    # Set the memory clock speed back up gpu clock speed

    nvtool --setcoreoffset 150 --setmem 0 --setclocks 1485 --setmemoffset -400

miner start
#    nohup $MAIN_MINER -G -L 0 --HWMON 1 -P stratum://89.169.41.217:3333
  fi
done