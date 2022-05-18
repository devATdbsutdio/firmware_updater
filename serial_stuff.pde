import java.io.InputStreamReader;
import processing.serial.*;
Serial uploadPort;

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
      // - /dev/tty.USB... or /dev/ttyAMA...
      if (port.substring(5, 12).equals("tty.USB") || port.substring(5, 12).equals("tty.AMA")) {
        //println(port);
        filteredPorts.append(port);
      }
    }
  }

  String[] workablePortsArray = filteredPorts.array();
  //String[] workablePortsArray = allSerialPorts.array();
  return workablePortsArray;
}




void run_cmd() {
  // While the command is running lock the UI
  //lockUIElements();
  
  //myTextarea.clear();
  //console.clear();

  printFlashCommand(flash_cmd);

  // 1. Run the command
  //try {
  //  //Process p = Runtime.getRuntime().exec(cmd);
  //  Process p = Runtime.getRuntime().exec(flash_cmd);
  //  // 2. Create a buffer reader to capture input stream. (Note: we are not capturing error stream
  //  // but it can be done)
  //  BufferedReader buff = new BufferedReader(new InputStreamReader(p.getInputStream()));
  //  String stdIn = null;
  //  // 3. Read a line and if it's not null, print it.
  //  while ((stdIn = buff.readLine()) != null) {
  //    println(stdIn.toString());
  //    //newOutputLine = stdIn.toString();
  //  }

  //  // 4. Check the exit code to be 100% sure, the command ran successfully (exitCode 0)
  //  int exitVal = p.waitFor();
  //  println("EXIT CODE:\t", str(exitVal));
  //  //newOutputLine = "EXIT CODE:\t" + str(exitVal);
  //  buff.close();

  //  if (exitVal == 0) {
  //    println("\n --- SUCCESFULLY FLASHED FIRMWARE: " + binHexFileName + "  ---");
  //  } else {
  //    println("\n --- ERROR WHILE FLASHING FIRMWARE: " + binHexFileName + " ---");
  //  }
  //}
  //catch (Exception e) {
  //  println("\nSome exception happened!");
  //  //newOutputLine = "some exception happened!";
  //  //e.printStackTrace();
  //}

  ///*
  // Don't know why I had to instantiate console here again. But this came out of trail and error.
  // Or else if we use println(), in this threaded fucntion, then we can only call the thread once,
  // or basicaly I don't know if the thread is called again, but I do not see any text output in the
  // sketch console.
  // */
  //console = cp5.addConsole(myTextarea);

  //// After the command has ran, Release the UI
  //unlockUIElements();
}
