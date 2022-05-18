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
  println("\nFLASHING CMD:\t" + cmd_buffer.toString() + "\n");
}

void sysinfo() {
  println( "SYS INFO :");
  println( "System:\t" + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  println( "JAVA:\t" + System.getProperty("java.home")  + " rev: " +javaVersionName);
  //println( System.getProperty("java.class.path") );
  //println( "\n" + isGL() + "\n" );
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
  //println(shortOSName);
  

  if (shortOSName.equals("mac")) {
    // TBD accomodate other mac OS name types
    osn = 0;
  } else if (shortOSName.equals("win")) {
    // TBD accomodate other indows name types
    osn = 1;
  } else if (shortOSName.equals("lin")) {
    osn = 2;
  } else {
    osn = 3;
  }

  // TEST
  // osn = 1;

  return osn;
}

String getPythonPath(int _osn) {
  String pyPath = "";
  if (_osn == 0) {
    // mac OS specific python3
    //pyPath = sketchPath() + "/tools/python3/macos/python3";
    pyPath = "python3";
  } else if (_osn == 1) {
    // windows specific python3
    pyPath = sketchPath() + "\\tools\\python3\\windows\\python3.exe";
  } else if (_osn == 2) {
    // linux specific python3
    //pyPath = sketchPath() + "/tools/python3/linux/python3";
    pyPath = "python3";
  } else {
    // TBD: Run shell command which python3 and grab the result
  }

  return pyPath;
}

String getPythonProgScptPath(int _osn) {
  String pyScptPath = "";
  if (_osn == 0) {
    // mac OS specific python3
    pyScptPath = sketchPath() + "/tools/prog.py";
  } else if (_osn == 1) {
    // windows specific python3
    pyScptPath = sketchPath() + "\\tools\\prog.py";
  } else if (_osn == 2) {
    // linux specific python3
    pyScptPath = sketchPath() + "/tools/prog.py";
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
  if (OS() == 0 || OS() == 2) {
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
  if (OS() == 1) {
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
    String[] strList = {binHexFilePath};
    // Writes the strings to a file, each on a separate line
    String infoFilePath = "";
    if (OS() == 0 || OS() == 2) {
      // mac or  linux
      infoFilePath = "data/" + binPathInfoFile;
    }
    if (OS() == 1) {
      // win
      infoFilePath = "data\\" + binPathInfoFile;
    }
    try {
      saveStrings(infoFilePath, strList);
      println("INFO FILE SAVED WITH BIN PATH INFO\n");
    }
    catch (Exception e) {
      println("FILE COULD NOT BE SAVED BECAUSE:\n");
      println(e);
    }
  }
}


// On first load ...
void loadAndSetBinaryFilePath(String filename) {
  String infoFilePath = "";
  if (OS() == 0 || OS() == 2) {
    // mac or  linux
    infoFilePath = "data/" + filename;
  }
  if (OS() == 1) {
    // win
    infoFilePath = "data\\" + filename;
  }
  
  // Chcek if file exists in path;
  File f = dataFile(getJustFileName(infoFilePath));
  String filePath = f.getPath();
  boolean exist = f.isFile();
  if (!exist) {
    return ;
  }  
  
  // if so, laod the strings from it. 
  try {
    String[] lines = loadStrings(filePath);
    if (lines.length == 0) {
      return ;
    }
    if (lines[0].length() == 0) {
      return ;
    }
    print("\nFOUND BIN PATH FROM INFO FILE:\n");
    binHexFilePath = lines[0]; // the first line is the path of the binary
    binHexFileName = getJustFileName(binHexFilePath);
    println(binHexFilePath);

    binFileLabel.setText(binHexFileName);

    // Update binary PATH in flash command
    flash_cmd[16] = binHexFilePath;
    //printFlashCommand(flash_cmd);
  }
  catch (Exception e) {
    println("NO INFO FILE FOUND!\n");
    //println(e);
  }
}
