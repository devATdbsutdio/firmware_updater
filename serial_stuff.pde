


String[] filterSerialList(StringList allSerialPorts) {
  StringList filteredPorts = new StringList();

  //println("\nfiltered ports:");

  if (OS() == 0) {
    // mac
    for (String port : allSerialPorts) {
      // - /dev/tty.usb...
      if (port.substring(5, 12).equals("tty.usb")) {
        //println(port);
        filteredPorts.append(port);
      }
    }
  }
  if (OS() == 1) {
    // win
    // TBD
    filteredPorts = allSerialPorts;
  }
  if (OS() == 2) {
    // linux
    for (String port : allSerialPorts) {
      // - /dev/tty.USB...
      if (port.substring(5, 12).equals("tty.USB")) {
        //println(port);
        filteredPorts.append(port);
      }
    }
  }

  //String[] workablePortsArray = filteredPorts.array();
  String[] workablePortsArray = allSerialPorts.array();
  return workablePortsArray;
}


/*
 String pythonPath;
 String progFilePath;
 String binHexFilePath;
 String binHexFileName";
 String uploadPortName;
 
 <pythonPATH> -u <prog.pyPATH> -t uart -u <SERIAL_PORT> -b 921600 -d attiny1607 --fuses 2:0x02 6:0x00 8:0x00 -f <BIN_PATH> -a write
 */



long timeOutSec = 180;

String line;

boolean ranCommandSuccsfully(String _cmd[]) {
  Process p = exec(_cmd);
  try {
    if (p.waitFor(timeOutSec, TimeUnit.SECONDS)) {
      return true;
    } else {
      return false;
    }
  }
  catch (InterruptedException e) {
    return false;
  }
}
