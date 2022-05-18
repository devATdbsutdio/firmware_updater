// Location where we store the previously selected binary's path
String binPathInfoFile = "path.txt";

String pythonPath = "PYTHON_PATH";
String progFilePath = "PROG.PY_PATH";
String binHexFilePath = "BIN_PATH";
String binHexFileName = "BIN_NAME";
// To be used later by UI, after selecting a port, this will be inserted in upload command
String uploadPortName = "SERIAL_PORT";



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

void printFlashCommand(String[] cmd) {
  StringBuffer cmd_buffer = new StringBuffer();
  for (int i = 0; i < cmd.length; i++) {
    cmd_buffer.append(cmd[i] + " ");
  }
  println("\nFLASHING CMD:\t" + cmd_buffer.toString());
}

void sysinfo() {
  println( "SYS INFO :");
  println( "System:\t" + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  println( "JAVA:\t" + System.getProperty("java.home")  + " rev: " +javaVersionName);
  //println( System.getProperty("java.class.path") );
  //println( "\n" + isGL());
  //println( "OPENGL     : VENDOR " + PGraphicsOpenGL.OPENGL_VENDOR+" RENDERER " + PGraphicsOpenGL.OPENGL_RENDERER+" VERSION " + PGraphicsOpenGL.OPENGL_VERSION+" GLSL_VERSION: " + PGraphicsOpenGL.GLSL_VERSION);
  //println( "user.home  : " + System.getProperty("user.home") );
  //println( "user.dir   : " + System.getProperty("user.dir") );
  //println( "user.name  : " + System.getProperty("user.name") );
  //println( "sketchPath : " + sketchPath() );
  //println( "dataPath:\t" + dataPath(""));
  //println( "dataFile:\t" + dataFile(""));
  println( "frameRate:\t"+nf(frameRate, 0, 1));
  //println( "canvas     : width "+width+" height "+height+" pix "+(width*height));
}

int OS() {
  int osn = 0;

  String fullOSName = System.getProperty("os.name");
  String shortOSName = fullOSName.substring(0, 3).toLowerCase();

  if (shortOSName.equals("mac")) {
    // TBD accomodate other mac OS name types
    osn = 0;
  }
  if (shortOSName.equals("lin")) {
    osn = 1;
  }
  if (shortOSName.equals("win")) {
    // TBD accomodate other indows name types
    osn = 2;
  }

  return osn;
}

String getPythonPath(int _osn) {
  String pyPath = "";
  if (_osn == 0) {
    // mac OS specific python3
    // TBD: fix bundled python3 issues.
    // pyPath = sketchPath() + "/tools/python3/macos/python3/python3";
    pyPath = "python3";
  }
  if (_osn == 1) {
    // linux specific python3
    pyPath = sketchPath() + "/tools/python3/linux/python3";
  }
  if (_osn == 2) {
    // windows specific python3
    pyPath = sketchPath() + "\\tools\\python3\\windows\\python3.exe";
  }



  return pyPath;
}

String getPythonProgScptPath(int _osn) {
  String pyScptPath = "";
  if (_osn == 0 || _osn == 1) {
    // mac OS ' Linux specific python3
    pyScptPath = sketchPath() + "/tools/prog.py";
  } else if (_osn == 2) {
    // windows specific python3
    pyScptPath = sketchPath() + "\\tools\\prog.py";
  } else {
    // TBD:
  }
  return pyScptPath;
}


// ------------------------------------- //
// function to strip file name form path //
// ------------------------------------- //
String getJustFileName(String filePath) {
  IntList arrayOfSlashIndices = new IntList();
  int idxOfSlash = 0;
  //for mac or linux
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

  //for windows
  if (OS() == 2) {
    idxOfSlash =  filePath.indexOf("\\");
    while (idxOfSlash >= 0) {
      //println(idxOfSlash);
      if (idxOfSlash!=0) {
        arrayOfSlashIndices.append(idxOfSlash);
      }
      idxOfSlash=filePath.indexOf("\\", idxOfSlash + 1);
    }
  }

  //printArray(arrayOfSlashIndices);
  int lastIdxOfSlash = arrayOfSlashIndices.get(arrayOfSlashIndices.size()-1);
  String filename = filePath.substring(lastIdxOfSlash+1, filePath.length());
  //println(filename);
  return filename;
}


void binaryFileSelected(File selection) {
  if (selection == null) {
    println("\nSELECTION ABORTED");
  } else {
    binHexFilePath = selection.getAbsolutePath();
    binHexFileName = getJustFileName(binHexFilePath);
    println("\nSELECTED BINARY FILE PATH:\t" + binHexFilePath);
    println("\nSELECTED BINARY FILE:\t" + binHexFileName);

    binFileLabel.setText(binHexFileName);

    // Update binary PATH in flash command
    flash_cmd[16] = binHexFilePath;
    //printFlashCommand(flash_cmd);

    // Save the file path info in a text file, for next time loading
    try {
      PrintWriter output = createWriter(binPathInfoFile); // create a new file
      output.println(binHexFilePath);
      output.flush(); // Writes the remaining data to the file
      output.close();
      println("INFO FILE SAVED WITH BIN PATH INFO");
    }
    catch (Exception e) {
      println("ERROR: [X] FILE COULD NOT BE SAVED!");
      return ;
    }
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
    //binHexFilePath = lines[0]; // the first line is the path of the binary
    binHexFilePath = line; // the first line is the path of the binary
    binHexFileName = getJustFileName(binHexFilePath);
    println(binHexFilePath);
    binFileLabel.setText(binHexFileName);

    // Update binary PATH in flash command
    flash_cmd[16] = binHexFilePath;
  }
  catch (Exception e) {
    return ;
  }
}
