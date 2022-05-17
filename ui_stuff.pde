/*
UI elements:
 1. [*][LIST] Select serial port.
 2. [*][Button] Refresh Ports.
 3. [*][Button] Load binary.
 4. [*][Text] show binary name.
 5. [-][Button] Upload to HW.
 6. [TBD] - [Toggle] upload loop.
 6. [TBD] - [Button] get latest firmware.
 Test on different OS
 */


int yellow_color = #F0C674;
int background_color = #1D1F21;
int washed_text_color = 150;
int locked_color = #B46758;
int highlight_color = #8EB559;

// font-aweosme icons: https://fontawesome.com/v5/cheatsheet
int refresh_ico = #00f021;
int file_ico = #00f15b;
//int upload_ico = #00f0ab;
//int upload_ico = #00f074;
int upload_ico = #00f061;
int toggle_on_ico = #00f205;
int toggle_off_ico = #00f204;


import controlP5.*;
ControlP5 cp5;


Textarea myTextarea;
Println console;
Icon refresh;
ScrollableList serialListMenu;
Icon uploadFile;
Textarea binFileLabel;
Icon burnFirmware;
Textlabel burn;


int buffGapWidth = 10;
int objHeights = 25;
int consoleYPos = 128;



void setupOnScreenConsosle(ControlFont f) {
  myTextarea = cp5.addTextarea("txt")
    .setPosition(buffGapWidth, consoleYPos)
    .setSize(width - buffGapWidth*2, height-(consoleYPos+buffGapWidth))
    .setFont(f)
    .setLineHeight(13)
    .setColor(color(80, 90, 90))
    .setColorBackground(color(#1D1F21))
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


void createSerialPortsMenu(ControlFont f) {
  // Create an StringList of all the Serial ports available
  StringList serialPortsList = new StringList();
  for (int i=0; i<Serial.list().length; i++ ) {
    serialPortsList.append(Serial.list()[i]);
  }
  //StringList workablePortsList = filterSerialList(serialPortsList);
  String[] workablePortsArray = filterSerialList(serialPortsList);
  //printArray(workablePortsArray);

  // Get position related to refresh icon
  float[] position = {
    refresh.getPosition()[0]+refresh.getWidth()+buffGapWidth,
    refresh.getPosition()[1]
  };

  serialListMenu = cp5.addScrollableList("serialPort")
    //.setPosition(buffGapWidth, 25)
    .setPosition(position[0], position[1])
    .setSize(220, 100)
    .setBarHeight(objHeights)
    .setFont(f)
    .setLabel("Ports ...")
    .setColorLabel(washed_text_color)
    .setItemHeight(objHeights)
    .addItems(workablePortsArray)
    //.setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .setType(ScrollableList.LIST)
    .close()
    ;
}

void createUploadFileButton() {
  // Get position related to refresh icon
  float[] position = {
    serialListMenu.getPosition()[0]+serialListMenu.getWidth()+buffGapWidth*2,
    serialListMenu.getPosition()[1]
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
  // Get position related to refresh icon
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

void createUploadFirmwareButton(ControlFont f) {
  // Get position related to refresh icon
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




void refreshPorts(int val) {
  println("\nREFRESHING SERIAL PORTS...\n");
  // Create an StringList of all the Serial ports available
  StringList serialPortsList = new StringList();
  for (int i=0; i<Serial.list().length; i++ ) {
    serialPortsList.append(Serial.list()[i]);
  }
  // StringList workablePortsList = filterSerialList(serialPortsList);
  String[] workablePortsArray = filterSerialList(serialPortsList);
  printArray(workablePortsArray);

  // Update the list
  // serialListMenu.addItems(workablePortsArray).update();
  serialListMenu.setItems(workablePortsArray).update();
}

void serialPort(int n) {
  uploadPortName = serialListMenu.getItem(n).get("text").toString();
  //println("\nSELECTED PORT:\t", uploadPortName);
  //serialListMenu.setLabel(uploadPortName).close();

  serialListMenu.setLabel(uploadPortName);
  if (serialListMenu.isMouseOver()) {
    serialListMenu.close();
    println("\nSELECTED PORT:\t", uploadPortName);
    //serialListMenu.close();
  }


  flash_cmd[6] = uploadPortName; // Update prog.py's PATH in flash command
  //printFlashCommand(flash_cmd);
}

void selectBinary(int val) {
  //println("\nUPLOAD FILE  .");
  selectInput("\nSELECT BINARY HEX FILE TO UPLAOD:", "binaryFileSelected");
}

void burnBinary(int n) {
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
  if (uploadPortName == null || uploadPortName.equals("") || uploadPortName.equals("SERIAL_PORT")) {
    println("\nWARNING:\t Serial port was not selected!");
    return ;
  }

  //printFlashCommand(flash_cmd);
  thread("run_cmd"); // it's the function that uses the flash_cmd
}

void lockUIElements() {
  refresh.lock();
  uploadFile.lock();
  burnFirmware.lock();

  refresh.setColorForeground(color(locked_color));
  uploadFile.setColorForeground(color(locked_color));
  burnFirmware.setColorForeground(color(locked_color));
}

void unlockUIElements() {
  refresh.unlock();
  uploadFile.unlock();
  burnFirmware.unlock();

  refresh.setColorForeground(color(yellow_color));
  uploadFile.setColorForeground(color(yellow_color));
  burnFirmware.setColorForeground(color(yellow_color));
}




boolean collapse;
int UIElementNumber = 0;
int serialMenuItemId = 0;

void keyPressed() {
  if (key == 'r' || key == 'R') {
    refreshPorts(1);
    ;
  }
  if (key == 'f' || key == 'F') {
    burnBinary(1);
  }


  if (key == TAB) {
    switch (UIElementNumber) {
    case 0:
      refresh.setColorForeground(color(highlight_color));
      uploadFile.setColorForeground(color(yellow_color));
      burnFirmware.setColorForeground(color(yellow_color));
      break;
    case 1:
      //serialListMenu.setMouseOver(false);
      serialListMenu.open();
      refresh.setColorForeground(color(yellow_color));
      uploadFile.setColorForeground(color(yellow_color));
      burnFirmware.setColorForeground(color(yellow_color));
      break;
    case 2:
      //serialListMenu.setMouseOver(true);
      serialListMenu.close();
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
      refreshPorts(1);
      break;
    case 1:
      if (serialListMenu.isOpen()) {
        serialListMenu.close();
        println("\nSELECTED PORT:\t", uploadPortName);
      } else {
        serialListMenu.open();
      }
      break;
    case 2:
      selectBinary(1);
      break;
    case -1:
      burnBinary(1);
      break;
    }
  }

  if (key == CODED) {
    if (serialListMenu.isOpen() == false) {
      return;
    }
    serialListMenu.setValue(serialMenuItemId).update();
    if (keyCode == UP) {
      //println("go up serial list");
      // TBD
      serialMenuItemId--;
      if (serialMenuItemId < 0) {
        serialMenuItemId = serialListMenu.getItems().size()-1;
      }
    }
    if (keyCode == DOWN) {
      //println("go down serial list");
      // TBD
      serialMenuItemId++;
      if (serialMenuItemId > serialListMenu.getItems().size()-1) {
        serialMenuItemId = 0;
      }
    }
  }


  if (key == 'h' || key == 'H') {
    collapse = !collapse;

    if (collapse) {
      surface.setResizable(true);
      surface.setSize(630, 128);
      surface.setResizable(false);

      myTextarea.setPosition(buffGapWidth, consoleYPos + 50);
      myTextarea.setHeight(2);
      myTextarea.hideScrollbar();
    } else {

      surface.setResizable(true);
      surface.setSize(630, 320);
      surface.setResizable(false);

      myTextarea.setPosition(buffGapWidth, consoleYPos);
      myTextarea.setHeight(height-(consoleYPos+buffGapWidth));
      myTextarea.showScrollbar();
    }
  }
}

void mousePressed() {
  //UIElementNumber = 0;
  refresh.setColorForeground(color(yellow_color));
  uploadFile.setColorForeground(color(yellow_color));
  burnFirmware.setColorForeground(color(yellow_color));
}
