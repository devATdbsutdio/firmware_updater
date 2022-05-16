void sysinfo() {
  println( "__SYS INFO :");
  println( "System     : " + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
  println( "JAVA       : " + System.getProperty("java.home")  + " rev: " +javaVersionName);
  //println( System.getProperty("java.class.path") );
  //println( "\n" + isGL() + "\n" );
  println( "OPENGL     : VENDOR " + PGraphicsOpenGL.OPENGL_VENDOR+" RENDERER " + PGraphicsOpenGL.OPENGL_RENDERER+" VERSION " + PGraphicsOpenGL.OPENGL_VERSION+" GLSL_VERSION: " + PGraphicsOpenGL.GLSL_VERSION);
  println( "user.home  : " + System.getProperty("user.home") );
  println( "user.dir   : " + System.getProperty("user.dir") );
  println( "user.name  : " + System.getProperty("user.name") );
  println( "sketchPath : " + sketchPath() );
  println( "dataPath   : " + dataPath("") );
  println( "dataFile   : " + dataFile("") );
  println( "frameRate  :  actual "+nf(frameRate, 0, 1));
  println( "canvas     : width "+width+" height "+height+" pix "+(width*height));
}

int OS() {
  int osn = 0;

  if (System.getProperty("os.name").equals("Mac OS X")) {
    // TBD accomodate other mac OS name types
    osn = 0;
  } else if (System.getProperty("os.name").equals("Windows")) {
    // TBD accomodate other indows name types
    osn = 1;
  } else if (System.getProperty("os.name").equals("Windows")) {
    osn = 2;
  } else {
    osn = 3;
  }
  return osn;
}

String getPythonPath(int _osn) {
  String pyPath = "";
  if (_osn == 0) {
    // mac OS specific python3
    pyPath = sketchPath() + "/tools/python3/macos/python3";
  } else if (_osn == 1) {
    // windows specific python3
    pyPath = sketchPath() + "\\tools\\python3\\windows\\python3.exe";
  } else if (_osn == 2) {
    // linux specific python3
    pyPath = sketchPath() + "/tools/python3/linux/python3";
  } else {
    // TBD: Run shell command which python3 and grab the result
  }

  return pyPath;
}



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
  
  try {
    String[] lines = loadStrings(infoFilePath);
    if (lines.length == 0) {
      return ;
    }
    if (lines[0].length() == 0) {
      return ;
    }
    print("FOUND BIN PATH FROM INFO FILE:\n");
    binHexFilePath = lines[0]; // the first line is the path of the binary
    binHexFileName = getJustFileName(binHexFilePath);
    println(binHexFilePath);
  }
  catch (Exception e) {
    println("NO INFO FILE FOUND!\n");
  }
}
