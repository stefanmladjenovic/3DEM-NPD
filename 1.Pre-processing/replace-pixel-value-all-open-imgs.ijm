// Stefan M. Mladjenovic 2024

// to replace pixel value of one type with another type

//apply on all open images
for (i=0;i<nImages;i++) {
        selectImage(i+1);
        run("Replace value", "pattern=255 replacement=0");
} 

