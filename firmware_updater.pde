void setup() {
  size(630, 320);
  background(25);
  surface.setTitle("WATCH FIRMWARE UPDATER [DATTA + BAUM STUDIOS BERLIN]");

  // ------------------------------------------------ //
  // Setup common color palettes for all the UI items.
  // -------------------------------------------------//
  cp5 = new ControlP5(this);
  cp5.enableShortcuts();
  cp5.setColorBackground(color(background_color))
    .setColorForeground(color(yellow_color))
    .setColorActive(color(yellow_color))
    .setColorValueLabel(color(yellow_color))
    ;

  // ---------------------------------------- //
  // Setup a common font for all the UI items.
  // ---------------------------------------- //
  ControlFont fontR11 = new ControlFont(loadFont("ABCDiatype-Regular-30.vlw"), 11); // use true/false for smooth/no-smooth
  ControlFont fontR14 = new ControlFont(loadFont("ABCDiatype-Light-14.vlw"), 14); // use true/false for smooth/no-smooth

  setupOnScreenConsosle(fontR14);


  sysinfo();

  // ----------------------------------------------------------------------------- //
  // Update python's PATH and prog.py's PATHs and consequitevly, the flash command.
  // ----------------------------------------------------------------------------- //
  pythonPath = getPythonPath(OS());
  progFilePath = getPythonProgScptPath(OS());
  flash_cmd[0] = pythonPath; // Update python's PATH in flash command
  flash_cmd[2] = progFilePath; // Update prog.py's PATH in flash command
  //printFlashCommand(flash_cmd);

  createRefreshSerialPortsButton();
  createDebugPortsMenu(fontR11);
  createUploadPortsMenu(fontR11);
  createUploadFileButton();
  createBinFileNameDisplay(fontR14);
  

  // ------------------------------------------------------------------------//
  // If we have used the software before and loaded a binary file,
  // we should have a file which contains it's PATH, load it if file exists.
  // ------------------------------------------------------------------------//
  loadAndSetBinaryFilePath(binPathInfoFile);

  createUploadFirmwareButton();
}


void draw() {
  background(15);
}
