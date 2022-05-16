import processing.serial.*;

Serial uploadPort;

// To be used later by UI, after selecting a port, thsi will be inserted in upload command
String uploadPortName = "";

// Location where we store the binary's previously selected path
String binPathInfoFile = "path.txt";


void setup() {
  size(680, 320);
  background(25);

  // Setup common color palettes for all the UI items
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  cp5.setColorBackground(color(#373B41))
    .setColorForeground(color(#F0C674))
    .setColorActive(color(#F0E474))
    .setColorValueLabel(color(#F0C674))
    ;

  // Setup a common font for all the UI items
  ControlFont fontR11 = new ControlFont(createFont("ABCDiatype-Regular", 30, true), 11); // use true/false for smooth/no-smooth

  setupOnScreenConsosle(fontR11);
  createRefreshSerialPortsButton();
  createSerialPortsMenu(fontR11);
  createUploadFileButton();


  //sysinfo();
  // OS() = 0 -> means mac
  // OS() = 1 -> means win
  // OS() = 3 -> means *nix
  //println("\n");
  //println(OS());
  println("INCLUDED PYTHON PATH: ", getPythonPath(OS()), "\n");

  //if we use the software before, we shoudl havea  file path, laod it if file exists
  loadAndSetBinaryFilePath(binPathInfoFile);
}

void draw() {
  background(15);
}
