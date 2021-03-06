/*
UI elements:
 1. [*][LIST] Select serial port.
 2. [*][Button] Refresh Ports.
 3. [*][Button] Load binary.
 4. [*][Text] show binary name.
 5. [*][Button] Upload to HW.
 7. [*] Test Exported APP on Mac OS.
 8. [*] Test Exported APP and adjust on Windows.
 9. [*] Test Exported APP on Linux. (yaml lib used by prog.py not working asked developer)
 10.[*] Icon lock/unlock bug resolve.
 11.[*] key board shortcut to show debugg port controls.
 12.[*] Debug port ui (port menu + switch)show hide.
 13.[*] Debug port ui (switch) enable disable logic.
 14.[TBD] Implement baud selection.
 15.[*] Open serial port and read result post test-firmware upload.
 16.[*] Implement physical disconnection Handler.
 17.[*] Implement clear console feature.
 */


int yellow_color = #F0C674;
int background_color = #1D1F21;
int washed_text_color = 150;
int locked_color = #B46758;
int highlight_color = #8EB559;

// font-aweosme icons: https://fontawesome.com/v5/cheatsheet
int refresh_ico = #00f021;
int file_ico = #00f15b;
int upload_ico = #00f061;
int toggle_on_ico = #00f205;
int toggle_off_ico = #00f204;


import controlP5.*;
ControlP5 cp5;


Textarea myTextarea;
Println console;
Icon refresh;
ScrollableList uploadSerialListMenu;
Textlabel uploadPortLabel;
ScrollableList debugSerialListMenu;
Textlabel debugPortLabel;
Icon uploadFile;
Textarea binFileLabel;
Icon burnFirmware;
Icon ToogleDebugSerial;
Textlabel debugSwitchLabel;


int buffGapWidth = 10;
int objHeights = 25;
int consoleYPos = 128;
int listItemHeight = 100;
int listItemWidth = 220;
int gapTopFromFrame = 35;

String emptyUploadPortMenuLabel = "Select upload port . . .";
String emptyDebugPortMenuLabel = "Select debug port . . .";


void setupOnScreenConsosle(ControlFont f) {
  myTextarea = cp5.addTextarea("txt")
    .setPosition(buffGapWidth + widthOfKeyBoardGuideFrame+12, consoleYPos+gapTopFromFrame)
    .setSize((width - buffGapWidth*2)-(widthOfKeyBoardGuideFrame+12), (height-(consoleYPos+buffGapWidth))-gapTopFromFrame)
    .setFont(f)
    .setLineHeight(13)
    .setColor(color(80, 90, 90))
    //.setColorBackground(color(#1D1F21))
    .setColorBackground(color(15))
    .setColorForeground(color(#F0C674))
    .enableCollapse()
    ;
  console = cp5.addConsole(myTextarea);
}

void createRefreshSerialPortsButton() {
  refresh = cp5.addIcon("refreshPorts", objHeights)
    .setPosition(buffGapWidth, 25)
    .setSize(objHeights, objHeights)
    .setFont(createFont("fontawesome-webfont.ttf", objHeights))
    .setFontIcons(refresh_ico, refresh_ico)
    .setSwitch(false)
    .hideBackground()
    ;
}


void createUploadPortsLabel(ControlFont f) {
  // Get position related to refresh icon
  float[] position = {
    refresh.getPosition()[0]+refresh.getWidth()+buffGapWidth, 
    refresh.getPosition()[1]-12
  };

  uploadPortLabel = cp5.addTextlabel("UPLOAD PORT")
    .setPosition(position[0], position[1])
    .setColorValue(100)
    .setFont(f)
    .setText("UPLOAD PORT")
    ;
}

void createUploadPortsMenu(ControlFont f) {
  // Create an StringList of all the Serial ports available
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

  String[] workablePortsArray = filterSerialList(serialPortsList);

  // Get position related to refresh icon
  float[] position = {
    refresh.getPosition()[0]+refresh.getWidth()+buffGapWidth, 
    refresh.getPosition()[1]
  };

  uploadSerialListMenu = cp5.addScrollableList("uploadPort")
    .setPosition(position[0], position[1])
    .setSize(listItemWidth, listItemHeight)
    .setBarHeight(objHeights)
    .setFont(f)
    .setLabel(emptyUploadPortMenuLabel)
    .setColorLabel(washed_text_color)
    .setItemHeight(objHeights)
    .addItems(workablePortsArray)
    //.setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .setType(ScrollableList.LIST)
    .close()
    ;

  createUploadPortsLabel(f);
}



void createDebugPortsLabel(ControlFont f) {
  // Get position related to refresh icon
  float[] position = {
    refresh.getPosition()[0]+refresh.getWidth()+buffGapWidth, 
    debugSerialListMenu.getPosition()[1] - 12
  };

  debugPortLabel = cp5.addTextlabel("DEBUG PORT")
    .setPosition(position[0], position[1])
    .setColorValue(100)
    .setFont(f)
    .setText("DEBUG   PORT")
    .hide()
    ;
}


void createDebugPortsMenu(ControlFont f) {
  // Create an StringList of all the Serial ports available
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

  String[] workablePortsArray = filterSerialList(serialPortsList);

  // Get position related to refresh icon & uploadSerialListMenu
  float[] position = {
    refresh.getPosition()[0]+refresh.getWidth()+buffGapWidth, 
    refresh.getPosition()[1]+buffGapWidth+listItemHeight/2.5, 
  };

  debugSerialListMenu = cp5.addScrollableList("debugPort")
    .setPosition(position[0], position[1])
    .setSize(listItemWidth, listItemHeight)
    .setBarHeight(objHeights)
    .setFont(f)
    .setLabel(emptyDebugPortMenuLabel)
    .setColorLabel(washed_text_color)
    .setItemHeight(objHeights)
    .addItems(workablePortsArray)
    //.setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .setType(ScrollableList.LIST)
    .close()
    .hide()
    ;

  createDebugPortsLabel(f);
}




void createToggleDebugSwitch(ControlFont f) {
  // Get position related to debug port list menu
  float[] position = {
    debugSerialListMenu.getPosition()[0] + (debugSerialListMenu.getWidth()+buffGapWidth*2)+5, 
    debugSerialListMenu.getPosition()[1]
  };

  ToogleDebugSerial = cp5.addIcon("debugPortSwitch", objHeights)
    .setPosition(position[0], position[1])
    .setSize(objHeights, objHeights)
    .setRoundedCorners(20)
    .setFont(createFont("fontawesome-webfont.ttf", objHeights*1.25))
    .setFontIcons(toggle_on_ico, toggle_off_ico)
    .setSwitch(true)
    .setColorBackground(color(255, 100))
    // onLoad it is default set to off
    .hide()
    ;


  createDebugSwitchLabel(f);
}


void createDebugSwitchLabel(ControlFont f) {
  // Get position related to refresh icon
  float[] position = {
    ToogleDebugSerial.getPosition()[0]+ToogleDebugSerial.getWidth()+buffGapWidth, 
    ToogleDebugSerial.getPosition()[1] + 7
  };

  debugSwitchLabel = cp5.addTextlabel("DEBUG PORT SWITCH")
    .setPosition(position[0], position[1])
    .setColorValue(100)
    .setFont(f)
    .setText("CLOSED")
    .hide()
    ;
}



void createUploadFileButton() {
  // Get position related to refresh icon
  float[] position = {
    uploadSerialListMenu.getPosition()[0]+uploadSerialListMenu.getWidth()+buffGapWidth*2, 
    uploadSerialListMenu.getPosition()[1]
  };

  uploadFile = cp5.addIcon("selectBinary", objHeights-2)
    .setPosition(position[0], position[1])
    .setSize(objHeights-2, objHeights-2)
    .setFont(createFont("fontawesome-webfont.ttf", objHeights-2))
    .setFontIcons(file_ico, file_ico)
    .setSwitch(false)
    .hideBackground()
    ;
}

void createBinFileNameDisplay(ControlFont f) {
  // Get position related to upload file icon
  float[] position = {
    uploadFile.getPosition()[0]+uploadFile.getWidth()+buffGapWidth, 
    uploadFile.getPosition()[1]
  };

  binFileLabel = cp5.addTextarea("binName")
    .setPosition(position[0], position[1])
    .setText(binHexFileName)
    .setFont(f)
    .setLabel("Test")
    .setSize(200, objHeights - 1)
    .setColor(washed_text_color)
    .setColorBackground(color(background_color))
    .hideScrollbar()
    ;
}

void createUploadFirmwareButton() {
  // Get position related to binary's name's space
  float[] position = {
    binFileLabel.getPosition()[0]+binFileLabel.getWidth()+buffGapWidth*3, 
    binFileLabel.getPosition()[1]
  };

  burnFirmware = cp5.addIcon("burnBinary", objHeights)
    .setPosition(position[0], position[1])
    .setSize(objHeights, objHeights)
    .setFont(createFont("fontawesome-webfont.ttf", objHeights))
    .setFontIcons(upload_ico, upload_ico)
    .setSwitch(false)
    .hideBackground()
    ;
}


void refreshPorts() {
  println("\nREFRESHING SERIAL PORTS...");
  // Create an StringList of all the Serial ports available
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

  String[] workablePortsArray = filterSerialList(serialPortsList);
  printArray(workablePortsArray);

  // Update the Port Menu lists
  uploadSerialListMenu.setItems(workablePortsArray).update();
  debugSerialListMenu.setItems(workablePortsArray).update();
  
  // if the previous port not is not there, update the header of the menu list
  if (!(portStillAvailable(uploadPortName))) {
    uploadSerialListMenu.setLabel(emptyUploadPortMenuLabel);
    uploadSerialListMenu.close();
    uploadSerialListMenu.setMouseOver(false);
    uploadPortName = "UPLOAD_PORT";
  }
  if (!(portStillAvailable(debugPortName))) {
    debugSerialListMenu.setLabel(emptyDebugPortMenuLabel);
    debugSerialListMenu.close();
    debugSerialListMenu.setMouseOver(false);
    debugPortName = "DEBUG_PORT";
    
  }
}



void uploadPort(int n) {
  uploadPortName = uploadSerialListMenu.getItem(n).get("text").toString();

  uploadSerialListMenu.setLabel(uploadPortName);
  if (uploadSerialListMenu.isMouseOver()) {
    uploadSerialListMenu.close();
    println("\nSELECTED UPLOAD PORT:\t", uploadPortName);
  }

  flash_cmd[6] = uploadPortName; // Update prog.py's PATH in flash command


  if (uploadPortName.equals(debugPortName) && ToogleDebugSerial.getBooleanValue() == true) {
    // if upload port is same as debug port and switch is open
    // disable switch
    ToogleDebugSerial.setOff();
    //enableDebugPortRead = false;
    println("\nSelected UPLOAD PORT:\t", uploadPortName, "\t is same as DEBUG PORT");
    println("Please change them to unique and then debug port will be enabled!");
  }
  if (!uploadPortName.equals(debugPortName) && ToogleDebugSerial.getBooleanValue() == false) {
    // if upload port is diff than debug port and switch is closed
    // enable switch
    ToogleDebugSerial.setOn();
    //enableDebugPortRead = true;
  }
}


void debugPort(int n) {
  debugPortName = debugSerialListMenu.getItem(n).get("text").toString();

  debugSerialListMenu.setLabel(debugPortName);
  if (debugSerialListMenu.isMouseOver()) {
    debugSerialListMenu.close();
    println("\nSELECTED DEBUG PORT:\t", debugPortName);
  }


  if (debugPortName.equals(uploadPortName) && ToogleDebugSerial.getBooleanValue() == true) {
    // if debug port is same as upload port and switch is open
    // disable switch
    ToogleDebugSerial.setOff();
    //enableDebugPortRead = false;
    println("\nSelected DEBUG PORT:\t", debugPortName, "\t is same as UPLOAD PORT");
    println("Please change them to unique and then debug port will be enabled!");
  }
  if (!debugPortName.equals(uploadPortName) && ToogleDebugSerial.getBooleanValue() == false) {
    // if debug port is diff than upload port and switch is closed
    // enable switch
    ToogleDebugSerial.setOn();
    //enableDebugPortRead = true;
  }
}


void debugPortSwitch(boolean on) {
  if (on) {
    //if turned on
    if (debugPortName.equals(uploadPortName)) {
      // if both ports are same, if serial was setup, flush and close
      ToogleDebugSerial.setOff();
      debugSwitchLabel.setText("CLOSED");
      enableDebugPortRead = false;

      println("\nSelected DEBUG PORT and UPLOAD PORT is same");
      println("Please change them to unique and then debug port will be enabled!");

      // if serial was setup, try to flush and close
      if (closeSerialPort()) {
        // if closed successfully, set it off
        println("SERIAL DEBUG PORT CLOSED");
      }
    } else {
      // if both ports are different, setup serial (if wasn't setup already)
      if (openSerialPort(debugPortName, serialReadBaud)) {
        // if opened successfully, keep it on
        enableDebugPortRead = true;
        debugSwitchLabel.setText("OPENED");
        println("SERIAL DEBUG PORT OPENED");
      } else {
        // if opened failed, turn it off
        ToogleDebugSerial.setOff();
        enableDebugPortRead = false;
        debugSwitchLabel.setText("CLOSED");
        println("SERIAL DEBUG PORT CANNOT BE OPENED");
      }
    }
  } else {
    // if triggered to turn off, keep the switch stay off
    enableDebugPortRead = false;
    debugSwitchLabel.setText("CLOSED");
    //if serial was setup, try to flush and close
    if (closeSerialPort()) {
      // if closed successfully
      println("SERIAL DEBUG PORT CLOSED");
    }
  }
}




void selectBinary() {
  //println("\nUPLOAD FILE  .");
  selectInput("\nSELECT BINARY HEX FILE TO UPLAOD:", "binaryFileSelected");
}



void burnBinary() {
  if (pythonPath == null || pythonPath.equals("") || pythonPath.equals("PYTHON_PATH")) {
    println("\nWARNING:\t Python path was not set / could not be found!");
    return ;
  }
  if (progFilePath == null || progFilePath.equals("") || progFilePath.equals("PROG.PY_PATH")) {
    println("\nWARNING:\t Programmer py script's path was not set / could not be found!");
    return ;
  }
  if (binHexFilePath == null || binHexFilePath.equals("") || binHexFilePath.equals("BIN_PATH")) {
    println("\nWARNING:\t Binary hex file's path was not set / could not be found!");
    return ;
  }
  if (uploadPortName == null || uploadPortName.equals("") || uploadPortName.equals("UPLOAD_PORT")) {
    println("\nWARNING:\t Serial port was not selected!");
    return ;
  }

  //printFlashCommand(flash_cmd);
  thread("run_cmd"); // it's the function that uses the flash_cmd
}

void lockUIElements() {
  refresh.lock()
    .setMouseOver(false)
    .setUpdate(false)
    .setColorForeground(color(locked_color))
    ;

  uploadFile.lock()
    .setMouseOver(false)
    .setUpdate(false)
    .setColorForeground(color(locked_color))
    ;

  burnFirmware.lock()
    .setMouseOver(false)
    .setUpdate(false)
    .setColorForeground(color(locked_color))
    ;
}


void unlockUIElements() {
  refresh.unlock()
    .setUpdate(true)
    .setColorForeground(color(yellow_color))
    ;

  uploadFile.unlock()
    .setUpdate(true)
    .setColorForeground(color(yellow_color))
    ;

  burnFirmware.unlock()
    .setUpdate(true)
    .setColorForeground(color(yellow_color))
    ;
}




boolean collapse;
int UIElementNumber = 0;
int portMenuItemId = 0;
boolean showDebugMenu = false;

void keyPressed() {
  if (key == 'c' || key == 'C') {
    console.clear();
  }
  if (key == 'r' || key == 'R') {
    refreshPorts();
    ;
  }
  if (key == 'f' || key == 'F') {
    burnBinary();
  }


  if (key == TAB) {
    switch (UIElementNumber) {
    case 0:
      refresh.setColorForeground(color(highlight_color));
      uploadFile.setColorForeground(color(yellow_color));
      burnFirmware.setColorForeground(color(yellow_color));
      break;
    case 1:
      //uploadSerialListMenu.setMouseOver(false);
      uploadSerialListMenu.open();
      refresh.setColorForeground(color(yellow_color));
      uploadFile.setColorForeground(color(yellow_color));
      burnFirmware.setColorForeground(color(yellow_color));
      break;
    case 2:
      //uploadSerialListMenu.setMouseOver(true);
      uploadSerialListMenu.close();
      refresh.setColorForeground(color(yellow_color));
      uploadFile.setColorForeground(color(highlight_color));
      burnFirmware.setColorForeground(color(yellow_color));
      break;
    case 3:
      refresh.setColorForeground(color(yellow_color));
      uploadFile.setColorForeground(color(yellow_color));
      burnFirmware.setColorForeground(color(highlight_color));
      break;
    }

    UIElementNumber++;
    if (UIElementNumber > 3) {
      UIElementNumber = 0;
    }
  }

  if (key == ENTER || key == RETURN) {
    switch (UIElementNumber-1) {
    case 0:
      refreshPorts();
      break;
    case 1:
      if (uploadSerialListMenu.isOpen()) {
        uploadSerialListMenu.close();
        println("\nSELECTED PORT:\t", uploadPortName);
      } else {
        uploadSerialListMenu.open();
      }
      break;
    case 2:
      selectBinary();
      break;
    case -1:
      burnBinary();
      break;
    }
  }

  if (key == CODED) {
    if (uploadSerialListMenu.isOpen() == false) {
      return;
    }
    uploadSerialListMenu.setValue(portMenuItemId).update();
    if (keyCode == UP) {
      //println("go up serial list");
      // TBD
      portMenuItemId--;
      if (portMenuItemId < 0) {
        portMenuItemId = uploadSerialListMenu.getItems().size()-1;
      }
    }
    if (keyCode == DOWN) {
      //println("go down serial list");
      // TBD
      portMenuItemId++;
      if (portMenuItemId > uploadSerialListMenu.getItems().size()-1) {
        portMenuItemId = 0;
      }
    }
  }


  if (key == 'd' || key == 'D') {
    //open extra panel with debug port
    showDebugMenu = !showDebugMenu;

    if (showDebugMenu) {
      debugSerialListMenu.show();
      debugPortLabel.show();
      ToogleDebugSerial.show();
      debugSwitchLabel.show();

      println("\nDEBUG CONTROL is now in view.");

      if (debugPortName == null) {
        ToogleDebugSerial.setOff();
        //enableDebugPortRead = false;
        println("\nCurrently DEBUG PORT is null.");
        println("Please select a valid DEBUG PORT and it will be Enabled!");
      } else if (debugPortName == uploadPortName) {
        ToogleDebugSerial.setOff();
        //enableDebugPortRead = false;
        println("\nSelected DEBUG PORT:\t", debugPortName, "\t is same as UPLOAD PORT");
        println("Please change and then it will be enabled!");
      } else if (debugPortName == "DEBUG_PORT") {
        ToogleDebugSerial.setOff();
        //enableDebugPortRead = false;
        println("\nDebug port will be enabled on debug port selection.");
      } else {
        ToogleDebugSerial.setOn();
        //enableDebugPortRead = true;
        println("\nSelected DEBUG PORT:\t", debugPortName);
      }

      println("\nIf you want to hide this debug section,");
      println("just press [d] in the keyboard to disable Debug port & hide this section.");
    } else {
      ToogleDebugSerial.setOff();
      //enableDebugPortRead = false;

      debugSerialListMenu.hide();
      debugPortLabel.hide();
      ToogleDebugSerial.hide();
      debugSwitchLabel.hide();

      println("\nDEBUG CONTROL is now hidden.");
      println("DEBUG PORT will be disabled.");
    }
  }
}




void mousePressed() {
  //UIElementNumber = 0;
  refresh.setColorForeground(color(yellow_color));
  uploadFile.setColorForeground(color(yellow_color));
  burnFirmware.setColorForeground(color(yellow_color));
}


// -- UI keyboard shortcut guide -- //
int textSize = 11;
int textVerticalGap = 6;
int totalKeyShortcuts = 8;
String[] keyInfo = {
  "[ESC]", 
  "[TAB]", 
  "[RETURN]", 
  "[CLICK]", 
  "[r/R]", 
  "[f/F]", 
  "[d/D]", 
  "[c/C]"
};
String[] keyAction = {
  "QUIT", 
  "CYCLE  UI", 
  "SELECT / SET", 
  "EXIT  TABBING", 
  "REFRESH  PORTS", 
  "FLASH  BINARY", 
  "TOGGLE  DEBUG", 
  "CLEAR CONSOLE"
};
String textSeparator = ":";

int widthOfKeyBoardGuideFrame = 144;
float frameStrokeWeight = 0.5;

void showKeyBoardGuide(int x, int y) {
  // Bounding box for keyboard shortcut text
  noFill();
  stroke(washed_text_color);
  strokeWeight(frameStrokeWeight);
  pushMatrix();
  translate(x-5, y);
  rectMode(CORNER);
  rect(0, 0, buffGapWidth + widthOfKeyBoardGuideFrame, height-(consoleYPos+buffGapWidth));
  popMatrix();

  // Header for keyBoard Guide frame
  noStroke();
  fill(washed_text_color);
  pushMatrix();
  translate(x-5, y);
  rectMode(CORNER);
  rect(0, 0, buffGapWidth + widthOfKeyBoardGuideFrame + frameStrokeWeight, gapTopFromFrame-8);
  textAlign(LEFT, CENTER);
  fill(50);
  text("SHORTCUTS", 5, 12);
  popMatrix();

  textSize(textSize);
  fill(washed_text_color);

  pushMatrix();
  translate(x-2, y+gapTopFromFrame);
  textAlign(LEFT, TOP);
  for (int id=0; id<totalKeyShortcuts; id++) {
    text(keyInfo[id], 0, (textSize+textVerticalGap)*id);
  }
  popMatrix();

  pushMatrix();
  translate((x+52.5)-2, y+gapTopFromFrame);
  textAlign(LEFT, TOP);
  for (int id=0; id<totalKeyShortcuts; id++) {
    text(textSeparator, 0, (textSize+textVerticalGap)*id);
  }
  popMatrix();

  pushMatrix();
  translate((x+60)-2, y+gapTopFromFrame);
  textAlign(LEFT, TOP);
  for (int id=0; id<totalKeyShortcuts; id++) {
    text(keyAction[id], 0, (textSize+textVerticalGap)*id);
  }
  popMatrix();

  // Bounding box for console
  noFill();
  stroke(washed_text_color);
  strokeWeight(frameStrokeWeight);
  pushMatrix();
  translate(buffGapWidth + widthOfKeyBoardGuideFrame+10, y);
  rectMode(CORNER);
  rect(0, 0, (width - buffGapWidth*2)-150, height-(consoleYPos+buffGapWidth));
  popMatrix();

  // Header for console frame
  noStroke();
  fill(washed_text_color);
  pushMatrix();
  translate(buffGapWidth + widthOfKeyBoardGuideFrame+10, y);
  rectMode(CORNER);
  rect(0, 0, (width - buffGapWidth*2)-(150-1), gapTopFromFrame-8);
  textAlign(LEFT, CENTER);
  fill(50);
  text("CONSOLE", 5, 12);
  popMatrix();
}
