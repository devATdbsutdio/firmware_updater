# firmware_updater
![Screenshot 2022-05-25 at 3 00 23 PM](https://user-images.githubusercontent.com/4619862/170200211-0835a531-3686-45f0-94be-1ac9f9143278.png)


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


### Binaries: 
1. [Mac app](https://github.com/devATdbsutdio/firmware_updater/releases/download/v1.0.0b/macos-x86_64.zip): Tested, for now, only on Intel Chips and not on M1 Macs and on latest (20/05/2022)  Mac OS Monterey (12.3.1)
2. [Win exe](https://github.com/devATdbsutdio/firmware_updater/releases/download/v1.0.0b/windows-amd64.zip): Tested, for now, only on Windows 10 stable release. 

### Note for Linux users: 
_Binaries are not yet ready for Linux Users unfortunately due to issues below (which we are trying to solve)_
> The Serial port access issue from GUI frame work. Posted [here](https://github.com/processing/processing4/issues/490) and [here](https://discourse.processing.org/t/serial-list-on-linux-doesnt-seem-to-work/37075)

