// Location where we store the previously selected binary's path
String binPathInfoFile = "path.txt";

String pythonPath = "PYTHON_PATH";
String progFilePath = "PROG.PY_PATH";
String binHexFilePath = "BIN_PATH";
String binHexFileName = "binary file [xxx.hex]";
// To be used later by UI, after selecting a port, this will be inserted in upload command
String uploadPortName = "UPLOAD_PORT";
String debugPortName = "DEBUG_PORT";

char[] splChars = {' ', '*', '\\', '/'}; // special characters in file anmes to look out for

String[] flash_cmd = {
  pythonPath, 
  "-u", 
  progFilePath, 
  "-t", 
  "uart", 
  "-u", 
  uploadPortName, 
  "-b", 
  "921600", 
  "-d", 
  "attiny1607", 
  "--fuses", 
  "2:0x02", 
  "6:0x00", 
  "8:0x00", 
  "-f", 
  binHexFilePath, 
  "-a", 
  "write"
};


void sysinfo() {
  //println( "SYS INFO :");
  println( "System:\t" + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  //println( "JAVA:\t" + System.getProperty("java.home")  + " rev: " +javaVersionName);
  println("\nOPERATION STEPS:");
  println("[1]. Select a port");
  println("[2]. Select firmware.");
  println("[3]. Upload.");
}




void printFlashCommand(String[] cmd) {
  StringBuffer cmd_buffer = new StringBuffer();
  for (int i = 0; i < cmd.length; i++) {
    cmd_buffer.append(cmd[i] + " ");
  }
  println("\nFLASHING CMD:\t" + cmd_buffer.toString());
}



// An utility fucntion to check if strings have spaces or "*" in them or not
// Will be used to notify users to not have spaces in the binary file names.
boolean fileNameOk(String fp) {
  boolean ok = false;

  ArrayList<Boolean> containsSplChar = new ArrayList<Boolean>();
  for (int i=0; i<splChars.length; i++) {
    containsSplChar.add(false);
  }
  for (int i=0; i<splChars.length; i++) {
    String[] p1 = split(fp, splChars[i]);
    if (p1.length > 1) {
      containsSplChar.set(i, true);
    }
  }
  if (containsSplChar.contains(true)) {
    ok = false;
  } else {
    ok = true;
  }

  return ok;
}


int OS() {
  int osn = 0;

  String fullOSName = System.getProperty("os.name");
  String shortOSName = fullOSName.substring(0, 3).toLowerCase();

  if (shortOSName.equals("mac")) {
    // TBD accomodate other mac OS name types (may be, if they vary)
    osn = 0;
  }
  if (shortOSName.equals("lin")) {
    // TBD accomodate other windows name types (may be, if they vary)
    osn = 1;
  }
  if (shortOSName.equals("win")) {
    // TBD accomodate other windows name types (may be, if they vary)
    osn = 2;
  }

  return osn;
}

String getPythonPath(int _osn) {
  String pyPath = "";

  switch (_osn) {
  case 0:
    // macOS specific portable python3 from tools dir
    // TBD fix bundled python3 issues.
    // pyPath = sketchPath() + "/tools/python3/macos/python3/python3";
    pyPath = "python3";
    break;
  case 1:
    // linux specific portable python3 from tools dir
    pyPath = sketchPath() + "/tools/python3/linux/python3";
    break;
  case 2:
    // windows specific portable python3 from tools dir
    pyPath = sketchPath() + "\\tools\\python3\\windows\\python3.exe";
    break;
  }

  return pyPath;
}

String getPythonProgScptPath(int _osn) {
  String pyScptPath = "";
  switch (_osn) {
  case 0:
    // macOS: where the prog.py is kept
    pyScptPath = sketchPath() + "/tools/prog.py";
    break;
  case 1:
    // linux: where the prog.py is kept
    pyScptPath = sketchPath() + "/tools/prog.py";
    break;
  case 2:
    // windows: where the prog.py is kept
    pyScptPath = sketchPath() + "\\tools\\prog.py";
    break;
  }

  return pyScptPath;
}


// ------------------------------------- //
// function to strip file name form path //
// ------------------------------------- //
String getJustFileName(String filePath) {
  IntList arrayOfSlashIndices = new IntList();
  int idxOfSlash = 0;
  // For mac or linux
  if (OS() == 0 || OS() == 1) {
    idxOfSlash =  filePath.indexOf("/");
    while (idxOfSlash >= 0) {
      //println(idxOfSlash);
      if (idxOfSlash!=0) {
        arrayOfSlashIndices.append(idxOfSlash);
      }
      idxOfSlash=filePath.indexOf("/", idxOfSlash + 1);
    }
  }

  // For windows
  if (OS() == 2) {
    idxOfSlash =  filePath.indexOf("\\");
    while (idxOfSlash >= 0) {
      if (idxOfSlash!=0) {
        arrayOfSlashIndices.append(idxOfSlash);
      }
      idxOfSlash=filePath.indexOf("\\", idxOfSlash + 1);
    }
  }


  int lastIdxOfSlash = arrayOfSlashIndices.get(arrayOfSlashIndices.size()-1);
  String filename = filePath.substring(lastIdxOfSlash+1, filePath.length());
  return filename;
}


void binaryFileSelected(File selection) {
  if (selection == null) {
    println("\nSELECTION ABORTED");
  } else {
    binHexFilePath = selection.getAbsolutePath();
    binHexFileName = getJustFileName(binHexFilePath);

    // Mitigate some in file names and re-format the Path
    fileNameOk(binHexFileName);

    if (fileNameOk(binHexFileName) == false) {
      enableFlashing = false;
      println("\n[WARNING]");
      println("INVALID FILE NAME/TYPE");
      println("The File has either SPACE/S or one of these characters (/ \\ *) in it.");
      println("Please RENAME the file without these characters");
      println("\nNOTE: Although you can use \"_\" in the file name");

      enableFlashing = false;
      //selection = null;
      return ;
    }

    // Save the file path info in a text file, for next time loading
    try {
      PrintWriter output = createWriter(binPathInfoFile); // create a new file
      output.println(binHexFilePath);
      output.flush(); // Writes the remaining data to the file
      output.close();
      println("\nINFO FILE SAVED WITH BIN PATH INFO");
    }
    catch (Exception e) {
      println("\nERROR: [X] INFO FILE containing just loaded firmware's path could not be saved");
      return ;
    }

    println("\nSELECTED BINARY FILE PATH:\t" + binHexFilePath);
    println("\nSELECTED BINARY FILE:\t" + binHexFileName);

    binFileLabel.setText(binHexFileName);

    // Update binary PATH in flash command
    flash_cmd[16] = binHexFilePath;

    enableFlashing = true;
  }
}


// On first load ...
void loadAndSetBinaryFilePath(String filename) {
  try {
    BufferedReader reader = createReader(filename);
    String line = "";

    line = reader.readLine();
    if (line == null) {
      return ;
    }
    print("\nFOUND BIN PATH FROM INFO FILE:");
    binHexFilePath = line; // the first line is the path of the binary
    binHexFileName = getJustFileName(binHexFilePath);

    // Mitigate some spl chars in file names and re-format the Path
    // binHexFilePath = accountForSpaces(binHexFilePath);
    if (fileNameOk(binHexFileName) == false) {
      enableFlashing = false;
      println("\n[WARNING] INVALID FILE NAME/TYPE"); 
      println("Tempered the name in the log (where we logged the last used file's location)");
      println("Now it has either SPACE/S or these characters (/ \\ *) in it.");
      println("Please RENAME the file name there (in the log file) and remove these characters.");
      println("\nNOTE: You can use \"_\" in the file name");

      enableFlashing = false;
      return ;
    }

    // Also check if the file truely exists or not?
    File f = new File(binHexFilePath);
    if (!f.exists()) {
      println("\n[WARNING]"); 
      println("Previously used file", binHexFileName, "doesn't exist in the path we recorded!");
      println("Or may be it was renamed.");
      println("Reload the firmware file to flash");
      enableFlashing = false;
      return ;
    }

    println("\nPreviously used file exists!");
    println(binHexFilePath);
    binFileLabel.setText(binHexFileName);

    // Update binary PATH in flash command
    flash_cmd[16] = binHexFilePath;

    enableFlashing = true;
  }
  catch (Exception e) {
    return ;
  }
}
