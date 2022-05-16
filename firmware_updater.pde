import java.util.concurrent.TimeUnit;
import java.util.Date;
import java.io.InputStreamReader;


import processing.serial.*;
Serial uploadPort;

// Location where we store the binary's previously selected path
String binPathInfoFile = "path.txt";

int yellow_color = #F0C674;
int background_color = #1D1F21;
int washed_text_color = 150;


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

  if (run_cmd) {
    String cmd[] = {"ping", "-c", "5", "www.google.com"};
    ProcessBuilder pb = new ProcessBuilder(cmd);
    
    pb.inheritIO();

    //ProcessBuilder processBuilder = new ProcessBuilder();
    //// -- Linux / mac -- Run a shell command
    //processBuilder.command("ping", "-c", "2", "www.google.com");
    // Run a shell script
    // processBuilder.command("path/to/hello.sh");
    // -- Windows -- Run a command
    //processBuilder.command("cmd.exe", "/c", "dir C:\\Users\\mkyong");

    try {
      Process process = pb.start();

      InputStream inputStream = process.getInputStream();
      reader = new BufferedReader(new InputStreamReader(inputStream));
      String res = "";
      while ((res = reader.readLine()) != null) {
        println(res);
      }
      int exitVal = process.waitFor();
      println(exitVal);
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    run_cmd = false;
  }
}
