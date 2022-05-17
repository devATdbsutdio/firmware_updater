


void setup() {
  size(630, 320);
  background(25);

  // Setup common color palettes for all the UI items
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  cp5.setColorBackground(color(background_color))
    .setColorForeground(color(yellow_color))
    .setColorActive(color(yellow_color))
    .setColorValueLabel(color(yellow_color))
    ;

  // Setup a common font for all the UI items
  ControlFont fontR11 = new ControlFont(createFont("ABCDiatype-Regular", 30, true), 11); // use true/false for smooth/no-smooth
  ControlFont fontR14 = new ControlFont(createFont("ABCDiatype-Light", 30, true), 14); // use true/false for smooth/no-smooth

  setupOnScreenConsosle(fontR11);

  // sysinfo();
  // OS() = 0 -> means mac
  // OS() = 1 -> means win
  // OS() = 3 -> means *nix
  // println("\n");
  // println(OS());
  println("INCLUDED PYTHON PATH: ", getPythonPath(OS()), "\n");

  createRefreshSerialPortsButton();
  createSerialPortsMenu(fontR11);
  createUploadFileButton();
  createBinFileNameDisplay(fontR14);

  // If we have used the software before, we should have a file path, load it if file exists
  // That file contains the PATH info of last loaded binary file that was most likely used.
  loadAndSetBinaryFilePath(binPathInfoFile);


  createUploadFirmwareButton(fontR14);
}



BufferedReader reader;
InputStream inputStream;

//String res;
boolean run_cmd;

void draw() {
  background(15);
}
