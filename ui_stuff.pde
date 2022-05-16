/*
UI elements:
 1. [*][LIST] Select serial port.
 2. [*][Button] Refresh Ports.
 3. [*][Button] Load binary.
 4. [-][Text] show binary name.
 5. [-][Button] Upload to HW.
 6. [TBD] - [Toggle] upload loop.
 6. [TBD] - [Button] get latest firmware.
 
 Test on different OS
 */

String UI_props_file = "props.properties";

// font-aweosme icons: https://fontawesome.com/v5/cheatsheet
int refresh_ico = #00f021;
int toggle_on_ico = #00f205;
int toggle_off_ico = #00f204;
int upload_ico = #00f0ab;
int file_ico = #00f15b;

import controlP5.*;
ControlP5 cp5;


Textarea myTextarea;
Println console;
Icon refresh;
ScrollableList serialListMenu;
Icon uploadFile;


int buffGapWidth = 10;
int objHeights = 25;
int consoleYPos = 100;



void setupOnScreenConsosle(ControlFont f) {
  myTextarea = cp5.addTextarea("txt")
    .setPosition(buffGapWidth, consoleYPos)
    .setSize(width - buffGapWidth*2, height-(consoleYPos+buffGapWidth))
    .setFont(f)
    .setLineHeight(13)
    .setColor(100)
    .setColorBackground(color(#1D1F21))
    .setColorForeground(color(#F0C674))
    ;
  console = cp5.addConsole(myTextarea);
}

void createRefreshSerialPortsButton() {
  refresh = cp5.addIcon("refreshPorts", objHeights)
    .setPosition(buffGapWidth, 25)
    .setSize(objHeights, objHeights)
    //.setRoundedCorners(2)
    .setFont(createFont("fontawesome-webfont.ttf", objHeights))
    .setFontIcons(refresh_ico, refresh_ico)
    .setSwitch(false)
    //.setColorBackground(color(255, 100))
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
    refresh.getPosition()[0]+refresh.getWidth()+10,
    refresh.getPosition()[1]
  };

  serialListMenu = cp5.addScrollableList("serialPort")
    //.setPosition(buffGapWidth, 25)
    .setPosition(position[0], position[1])
    .setSize(220, 100)
    .setBarHeight(objHeights)
    .setFont(f)
    .setLabel("Ports ...")
    .setColorLabel(150)
    .setItemHeight(objHeights)
    .addItems(workablePortsArray)
    .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .close()
    ;
}

void createUploadFileButton() {
  // Get position related to refresh icon
  float[] position = {
    serialListMenu.getPosition()[0]+serialListMenu.getWidth()+10*2,
    serialListMenu.getPosition()[1]
  };

  uploadFile = cp5.addIcon("uploadBinary", objHeights-2)
    .setPosition(position[0], position[1])
    .setSize(objHeights-2, objHeights-2)
    //.setRoundedCorners(2)
    .setFont(createFont("fontawesome-webfont.ttf", objHeights-2))
    .setFontIcons(file_ico, file_ico)
    .setSwitch(false)
    //.setColorBackground(color(255, 100))
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
  println("\nSELECTED PORT:\t", uploadPortName);
  //serialListMenu.setLabel(uploadPortName).close();
}

void uploadBinary(int val) {
  println("\nUPLOAD FILE  .");
  selectInput("\nSELECT BINARY HEX FILE TO UPLAOD:", "binaryFileSelected");
}


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

// ------------------------------------- //
// function to strip file name form path //
// ------------------------------------- //
void binaryFileSelected(File selection) {
  if (selection == null) {
    println("\nSELECTION ABORTED");
  } else {
    binHexFilePath = selection.getAbsolutePath();
    binHexFileName = getJustFileName(binHexFilePath);
    println("\nSELECTED BINARY FILE PATH:\t" + binHexFilePath);
    println("\nSELECTED BINARY FILE:\t" + binHexFileName);

    // Save the file path info in a text file, for next time loading
    String[] strList = {binHexFilePath};
    // Writes the strings to a file, each on a separate line
    try {
      String infoFilePath = "";
      if (OS() == 0 || OS() == 2) {
        // mac or  linux
        infoFilePath = "data/" + binPathInfoFile;
      }
      if (OS() == 1) {
        // win
        infoFilePath = "data\\" + binPathInfoFile;
      }
      saveStrings(infoFilePath, strList);
      println("INFO FILE SAVED WITH BIN PATH INFO\n");
    }
    catch (Exception e) {
      println("FILE COULD NOT BE SAVED BECAUSE:\n");
      println(e);
    }
  }
}
