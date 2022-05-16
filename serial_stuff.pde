String binHexFilePath = "<bin path>";
String binHexFileName = "<bin name>";

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
