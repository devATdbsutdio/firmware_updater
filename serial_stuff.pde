import java.io.InputStreamReader;
import processing.serial.*;
Serial serialReadPort;
int serialReadBaud = 115200;

boolean enableFlashing = false;
boolean enableDebugPortRead = false;

/*
 AS OF MAY-2022, if using Processing 4.0b8, the serial library is broken for Linux. 
 Specifically Serial.list() method doesn't list all available serial ports in LInux.
 So you want to use this version of IDE, anyways in Linux, Un comment the below function block. 
 */
/*
StringList getSerialPortsInLinux() {
 StringList serialPortsList = new StringList();
 String[] get_ports_cmd = {"bash", "-c", "ls /dev/tty*"};
 try {
 Process p = Runtime.getRuntime().exec(get_ports_cmd);
 // 2. Create a buffer reader to capture input stream. (Note: we are not capturing error stream
 // but it can be done)
 BufferedReader buff = new BufferedReader(new InputStreamReader(p.getInputStream()));
 String stdIn = null;
 // 3. Read a line and if it's not null, print it.
 while ((stdIn = buff.readLine()) != null) {
 //println(stdIn.toString());
 serialPortsList.append(stdIn.toString());
 }
 // 4. Check the exit code to be 100% sure, the command ran successfully (exitCode 0)
 int exitVal = p.waitFor();
 println("Serial Ports list command's EXIT CODE:\t", str(exitVal));
 buff.close();
 }
 catch (Exception e) {
 //println("Running Serial Ports list command had exceptions");
 serialPortsList = null;
 }
 return serialPortsList;
 }
 */



String[] filterSerialList(StringList allSerialPorts) {
  StringList filteredPorts = new StringList();

  //println("\nfiltered ports:");

  if (OS() == 0) {
    // mac
    for (String port : allSerialPorts) {
      // subtring pattern: /dev/tty.usb... (avoid bluetooth and others that appear on tty.xx or cu.xx)
      if (port.substring(5, 12).equals("tty.usb")) {
        //println(port);
        filteredPorts.append(port);
      }
    }
  }
  if (OS() == 1) {
    // linux
    for (String port : allSerialPorts) {
      // subtring pattern: /dev/ttyUSB... or /dev/ttyAMA... (avoid tty0-xx and ttys0-xx)
      if (port.length() >= 11) {
        if (port.substring(5, 11).equals("ttyUSB") || port.substring(5, 11).equals("ttyAMA")) {
          //println(port);
          filteredPorts.append(port);
        }
      }
    }
  }
  if (OS() == 2) {
    // win : All the ports basically, as nothing else shows up usually as COMxx
    filteredPorts = allSerialPorts;
  }

  String[] workablePortsArray = filteredPorts.array();
  return workablePortsArray;
}




void run_cmd() {
  if (!enableFlashing) {
    println("\n[WARNING]");
    println("The attempted file selection didn't work because of invalid filename");
    println("And you tried to flash!");
    println("So we are stopping this attempt to flash firmware file");
    /*
     Don't know why I had to instantiate console here again. But this came out of trail and error.
     Or else if we use println(), in this threaded fucntion, then we can only call the thread once,
     or basicaly I don't know if the thread is called again, but I do not see any text output in the
     sketch console.
     */
    console = cp5.addConsole(myTextarea);
    return ;
  }

  // Also Check if flashing firmware truely exists
  File f = new File(flash_cmd[16]);
  if (!f.exists()) {
    println("\n[WARNING]");
    println("Previously used file", flash_cmd[16], "doesn't exist!");
    println("And you tried to flash!");
    println("So we are stopping this attempt to flash firmware file");
    println("\nReload the firmware file to flash");
    /*
     Don't know why I had to instantiate console here again. But this came out of trail and error.
     Or else if we use println(), in this threaded fucntion, then we can only call the thread once,
     or basicaly I don't know if the thread is called again, but I do not see any text output in the
     sketch console.
     */
    console = cp5.addConsole(myTextarea);
    return ;
  }

  println("\nPreviously used file exists!");


  // While the command is running lock the UI
  lockUIElements();

  printFlashCommand(flash_cmd);

  // 1. Run the command
  try {
    //Process p = Runtime.getRuntime().exec(cmd);
    Process p = Runtime.getRuntime().exec(flash_cmd);
    // 2. Create a buffer reader to capture input stream. (Note: we are not capturing error stream
    // but it can be done)
    BufferedReader buff = new BufferedReader(new InputStreamReader(p.getInputStream()));
    String stdIn = null;
    // 3. Read a line and if it's not null, print it.
    while ((stdIn = buff.readLine()) != null) {
      println(stdIn.toString());
    }

    // 4. Check the exit code to be 100% sure, the command ran successfully (exitCode 0)
    int exitVal = p.waitFor();
    println("EXIT CODE:\t", str(exitVal));
    buff.close();

    if (exitVal == 0) {
      println("\n --- SUCCESFULLY FLASHED FIRMWARE: " + binHexFileName + "  ---");
      //
      // [TBD] At this stage open serial port: ... & read data...
      // if (enableDebugPortRead)
    } else {
      println("\n --- ERROR WHILE FLASHING FIRMWARE: " + binHexFileName + " ---");
    }
  }
  catch (Exception e) {
    println("\nSome exception happened!");
    return ;
  }

  /*
   Don't know why I had to instantiate console here again. But this came out of trail and error.
   Or else if we use println(), in this threaded fucntion, then we can only call the thread once,
   or basicaly I don't know if the thread is called again, but I do not see any text output in the
   sketch console.
   */
  console = cp5.addConsole(myTextarea);

  // After the command has ran, Release the UI
  unlockUIElements();
}



boolean closeSerialPort() {
  boolean portClosed = false;
  if (serialReadPort != null) {
    println("SERIAL DEBUG PORT WAS FOUND OPEN. CLOSING ...");
    serialReadPort.clear();
    try {
      serialReadPort.dispose();
      serialReadPort.stop();
      serialReadPort = null;
      if (serialReadPort == null) {
        portClosed = true;
      } else {
        portClosed = false;
        //println("For some reason Serial port is not null. So not closing...");
      }
    }
    catch(Exception e) {
      //println("Exception closing Serial port");
      portClosed = false;
    }
  } else {
    //println("Serial port is null, so not closing");
    portClosed = false;
  }
  return portClosed;
}


boolean openSerialPort(String portName, int baudRate) {
  boolean portOpened = false;
  if (serialReadPort == null) {
    if (!portName.equals("DEBUG_PORT")) {
      try {
        println("A VALID SERIAL DEBUG PORT WAS FOUND. OPENING ...");
        serialReadPort = new Serial(this, portName, baudRate);
        if (serialReadPort != null) {
          serialReadPort.bufferUntil('\n');
          serialReadPort.clear();
          portOpened = true;
          // Start a thread to watch Serial port, if it was physically still connected
          // Accordingly update the switch.
          thread("watchSerialStatus");
        } else {
          portOpened = false;
          //println("For some reason, Serial port is still null, so not opening!");
        }
      }
      catch(Exception e) {
        portOpened = false;
        //println("Exception opening Serial port");
      }
    } else {
      //println("Serail port name is", "DEBUG_PORT", ". So not attempting to open");
      portOpened = false;
    }
  } else {
    //println("Serial port in not null, so not opening");
    portOpened = false;
  }
  return portOpened;
}






StringList currPorts() {
  StringList serialPortsList = new StringList();
  /*
   AS OF MAY-2022, if using Processing 4.0b8, the serial library is broken for Linux. 
   Specifically Serial.list() method doesn't list al; available serial ports in LInux.
   So you want to use 4.0b8 version of IDE, anyways in Linux, Un comment the below block. 
   */
  /*
  // For Linux -> **Spl method due to bug for which Serial.list() doesn't work in linux
   if (OS() == 1) {
   //printArray(get_serial_ports_in_linux());
   serialPortsList = getSerialPortsInLinux();
   }
   // For mac and win
   if (OS() == 0 || OS() == 2) {
   for (int i=0; i<Serial.list().length; i++ ) {
   serialPortsList.append(Serial.list()[i]);
   }
   }
   */
  /*
   AS OF MAY-2022, if using Processing 3.5.4, the serial library is working for Linux. 
   Specifically Serial.list() method correctly lists all available serial ports in Linux.
   So you want to use 3.5.4 version of IDE, in Linux (Recommened until seril bug is foxed in Ver 4.X), 
   Comment out this for loop block below
   */
  for (int i=0; i<Serial.list().length; i++ ) {
    serialPortsList.append(Serial.list()[i]);
  }

  return serialPortsList;
}

boolean portStillAvailable(String portToCheck) {
  boolean available = false;
  for (String port : currPorts()) {
    if (port.equals(portToCheck)) {
      available = true;
      break;
    } else {
      available = false;
    }
  }
  return available;
}

void watchSerialStatus() {
  while (true) {
    // if serial port was opened in past successfully
    if (enableDebugPortRead) {
      // if serial port was physically disconnected
      if (!(portStillAvailable(debugPortName))) {
        ToogleDebugSerial.setOff();

        // remove the port from list
        debugSerialListMenu.removeItem(debugPortName);
        debugSerialListMenu.update();
        //d
        debugSerialListMenu.setLabel(emptyDebugPortMenuLabel);
        debugSerialListMenu.close();
        debugSerialListMenu.setMouseOver(false);
        debugPortName = "DEBUG_PORT";
      }
    }
    delay(3000);
  }
}
