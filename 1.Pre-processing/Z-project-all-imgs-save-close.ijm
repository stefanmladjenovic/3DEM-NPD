// Stefan M. Mladjenovic 2024

// use this script afer running the python/Jython script: Jython-get-dirs-align.py

// now that all images are open as windows, apply z-project to all of them then save each image. lastly close all open windows

// get image IDs of all open images
dir = getDirectory("Choose a Directory");
for (i=0;i<nImages;i++) {
        selectImage(i+1);
        title = getTitle;
        print(title);
        run("Z Project...", "projection=[Max Intensity]");
        saveAs("tiff", dir+title+"_MAX");
} 
//run("Close All");
// Close all doesn't work. but this following code does work to close all open windows

while (nImages>0) { 
  selectImage(nImages); 
  close(); 
}
