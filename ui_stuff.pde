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

String UI_props_file = "props.properties";



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

Button b;
Icon burnFirmware;
Textlabel burn;


int buffGapWidth = 10;
int objHeights = 25;
int consoleYPos = 100;



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
    .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .close()
    ;
}

void createUploadFileButton() {
  // Get position related to refresh icon
  float[] position = {
    serialListMenu.getPosition()[0]+serialListMenu.getWidth()+buffGapWidth*2,
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

  //burn = cp5.addTextlabel("BURN")
  //  .setPosition(position[0], position[1] + 4)
  //  .setText("FLASH")
  //  .setColor(color(washed_text_color))
  //  .setFont(f)
  //  ;

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
  println("\nSELECTED PORT:\t", uploadPortName);
  //serialListMenu.setLabel(uploadPortName).close();
}

void uploadBinary(int val) {
  println("\nUPLOAD FILE  .");
  selectInput("\nSELECT BINARY HEX FILE TO UPLAOD:", "binaryFileSelected");
}




boolean collapse;
void keyPressed() {

  if (key == 'c') {
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

  if (key == 'r') {
    
    run_cmd = true;

    //try {
    //  Process pb = exec("ping", "-c", "5", "www.google.com");
      
    //  reader = new BufferedReader(new InputStreamReader(pb.getInputStream()));

    //  while ((res = reader.readLine()) != null) {
    //    println(res);
    //  }
    //  //int exitVal = pb.waitFor();
    //}
    //catch (IOException e) {
    //  e.printStackTrace();
    //  res = null;
    //}

    //ProcessBuilder pb = new ProcessBuilder("ping", "-c", "5", "www.google.com");
    //pb.inheritIO();
    //try {
    //  Process p = pb.start();
    //  //int exitStatus = p.waitFor();
    //  //System.out.println(exitStatus);

    //  p.waitFor();

    //  InputStream inputStream = p.getInputStream();
    //  BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
    //  String responseLine = "";
    //  //StringBuilder output = new StringBuilder();
    //  while (( responseLine = reader.readLine())!= null) {
    //    //output.append(responseLine + "\n");
    //    //d = responseLine + "\n";
    //    System.out.println(responseLine + "\n");
    //    //println(output + "\n");
    //    //myTextarea.setText(output + "\n");
    //  }
    //}
    //catch (InterruptedException | IOException x) {
    //  println("test");
    //  x.printStackTrace();
    //}
  }
}
