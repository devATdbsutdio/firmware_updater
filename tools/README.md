# user_prog
HW and SW for user to flash new firmware

### To flash test firmware:
```shell
python3 -u prog.py -t uart -u /dev/tty.usbserial-1411140 -b 921600 -d attiny1607 --fuses 2:0x02 6:0x00 8:0x00 -f binaries/watch_firmware.hex -a write -v
```

### To flash main firmware:
```shell
python3 -u prog.py -t uart -u /dev/tty.usbserial-1411140 -b 921600 -d attiny1607 --fuses 2:0x02 6:0x00 8:0x00 -f binaries/components_check.hex -a write -v
```
