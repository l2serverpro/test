]
#!/bin/bash

# Set up variables
ZIL_MINER="/hive/miners/rigel/1.9.1/rigel"
ZIL_POOL="stratum+tcp://eu.crazypool.org:5005"
ZIL_WALLET="zil1a5q5amvpx48s97hac2wx6jrsu7ea0g6fvyrnsu"

# Start Zilliqa mining
echo "Start Zilliqa mining + NIM mining"
nohup $ZIL_MINER  -a zil --zil-cache-dag off -o $ZIL_POOL -u $ZIL_WALLET --zil-countdown -p x -w 3090malen > rigel.log 2>&1 &

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

    # SET FOR ZIL
    # SET FOR ZIL

<-->miner stop
  elif [[ $line == *"Zilliqa session finished"* ]]; then
    echo "Zilliqa mining finished, starting MAIN"

    # SET FOR MAIN
    # SET FOR MAIN
<-->miner start
  fi
done
