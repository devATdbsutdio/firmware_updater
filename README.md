# firmware_updater
![Application's image](https://user-images.githubusercontent.com/4619862/170832939-77a36578-2408-404f-851e-49456c3cf101.png)

## Development Environment:
Processing 3.5.4
> Note: Processing 4.0b8 has Bugs, Specifically for Serial API. Highlighted [here in github issues](https://github.com/processing/processing4/issues/490) & [here in forum](https://discourse.processing.org/t/serial-list-on-linux-doesnt-seem-to-work/37075)

## Operation:
### To Flash PCB test firmware:
The firmware that should run in the test PCB does things like, on Power ON, it checks various components and reports over serial.
So we need a Debug serial port (currently which is different than flashing port). 
> The serial port's baudrate is hardcoded at 115200. So make sure your hardware spits data over serial at 115200 baudrate. In the next version we will also open it up to the user of this system. 
1. Open the application. 
2. Pressing `d/D` on the keyboard to toggle show/hide the __Debug operation__ related UI elements.  
3. Plug in your programmer to your computer (programmer should be attached to the main board as well through UPDI pinouts).
4. Plug in the USB cable coming from the Debug port, to your computer. (_The System is deisgned for platforms where we have the Flashing port and Serial ports on two separate interfaces in the hardware_)
5. Click on the <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/sync-alt.svg" width="20" height="20"> to refresh serial port. _Everytime the programmer or the Serial interface is changed or replugged in, do not forget to refresh the ports._
6. Select your Upload port from it's respective dropdown list.
7. Select your Serial Debug port from it's respective dropdown list. 
8. Click on the <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/file.svg" width="20" height="20"> to select the test firmware binary i.e. [watch_firmware.hex](https://watchfirmware.s3.ap-northeast-1.amazonaws.com/watch_firmware.hex) (from the location where you downloaded it)
9. When ready, click on the <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/arrow-right.svg" width="20" height="20"> to flash the test firmware. 

### To Flash production firmware:
Depending on the usecase, the firmware typically should not have any serial debug logs coming from it, unless that's intended. If it is so intended as the later use-case, Then to flash and test even the production firmware, you can use the methods from last step. 
> If you do not need the 2nd Debug Serial port in this case, you can hide the Debug UI elements by pressing `d/D` on the keyboard. 
1. Open the application. 
2. Plug in your programmer to your computer (programmer should be attached to the main board as well through UPDI pinouts). 
3. Click on the <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/sync-alt.svg" width="20" height="20"> to refresh serial port. _Everytime the programmer is changed or replugged in, do not forget to refresh the ports._ 
5.  Select your Upload port from it's respective dropdown list.
6. Click on the <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/file.svg" width="20" height="20"> to select the firmware binary i.e. [watch_firmware.hex](https://watchfirmware.s3.ap-northeast-1.amazonaws.com/watch_firmware.hex) (from the location where you downloaded it)
7. When ready, click on the <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/arrow-right.svg" width="20" height="20"> to flash the main firmware. 

Keyboard shortcuts summary: 
1. `h/H` to toggle show hide console.
2. `r/R` to refresh serial ports list. (STEP-3)
3. `f/F` to flash binary. (STEP-7)
4. `c/C` clear the console area. 
5. `d/D` toggle show/hide Serial debug UI elements. 
6. `ESC` to Quit.
7. `TAB` to cycle through <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/sync-alt.svg" width="20" height="20"> <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/file.svg" width="20" height="20"> <img src="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/5.x/svgs/solid/arrow-right.svg" width="20" height="20">
8. While __tabbing__, press `ENTER/RETURN` to commit/select an operation. 
9. To get out of __tabbing__, perform `LEFT-MOUSE` click.


## Prerequisites:
### Check / Install Python on your system:
1. __MacOS users__: Although different versions of MacOS comes shipped with differernt versions of python, a quick way to check would be: 
   - Open your _SPOTLIGHT_ search (`CMD + SPACE`).
   - Type in `terminal`.
   - When terminal launches, type in: `python3`. 
   - If it is not installed, install it by going to this [link](https://www.python.org/downloads/macos/).
2. __Windows users__: No need to do anything, we have bundled a suitable python. 
3. __Linux users__: You guys know what you are doing 🤓. Python3 should be there or else what are you doing in Linux.   

### Install update Drivers on your system:
1. __MacOS users__: MacOS should also come with the serial drivers for the chip we are using, but no harm in upgrading. Install from [here](https://github.com/devATdbsutdio/firmware_updater/blob/main/tools/drivers/CH34XSER_MAC.zip). 
2. __Windows users__: Windows should also come with the serial drivers for the chip we are using, but no harm in upgrading. Install from [here](https://github.com/devATdbsutdio/firmware_updater/blob/main/tools/drivers/CH34XSER_WIN.zip).
3. __Linux users__: Follow this guide [here](https://gist.github.com/dattasaurabh82/082d13fd61c0d06c7a358c5e605ce4fd). 


## Binaries: 
1. [Mac app](https://github.com/devATdbsutdio/firmware_updater/releases/download/v1.0.0b/macos-x86_64.zip): Tested, for now, only on Intel Chips and not on M1 Macs and on latest (20/05/2022)  Mac OS Monterey (12.3.1)
2. [Win exe](https://github.com/devATdbsutdio/firmware_updater/releases/download/v1.0.0b/windows-amd64.zip): Tested, for now, only on Windows 10 stable release.
