import java.io.InputStreamReader;
import processing.serial.*;
Serial uploadPort;

boolean enableFlashing = false;


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
      // subtring pattern: /dev/tty.USB... or /dev/ttyAMA... (avoid tty0-xx and ttys0-xx)
      if (port.substring(5, 12).equals("ttyUSB") || port.substring(5, 12).equals("ttyAMA")) {
        //println(port);
        filteredPorts.append(port);
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
