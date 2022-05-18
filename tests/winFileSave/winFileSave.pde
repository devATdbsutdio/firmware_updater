void setup() {
}

void draw() {
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    // save file
    String info_file_name = "info.txt";

    String[] data = {"binary's file's absolute path"};
    saveStrings(info_file_name, data);

    // load test
    BufferedReader reader = createReader(info_file_name);
     String line = "";
    try {
      line = reader.readLine();
      println(line);
    }
    catch (IOException e) {
      e.printStackTrace();
      line = null;
      return ;
    }
  }
}
