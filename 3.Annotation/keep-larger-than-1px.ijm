// Stefan M. Mladjenovic 2024

// summary:
// align dataset
// do labkit annotation on NPs
// export segmentation from Labkit
// run watershed on Labkit NP export --> separates NP annotations that are connected
// use this script to analyze particles from 2-infinity to only get a mask NPs greater than 1px (removes noise). 
// this produces a mask which needs to be inverted to set bg to black and foreground (i.e. NPs larger than 1*1px) to white. 
	// *** UPDATE: actually the LUT is inverted, but the image is not inverted. Only need to invert the LUT. 
// lastly, review the stack to see if there are any errors/abnormalities with NP annotation 
// manually to remove/clear any slices where the tissue is damaged leading to NP annotation errors. The specific slices are described at bottom of this script and are commented out. 


// this script gets rid of 1x1 pixel noise from annotations after Labkit. 


// open image
open("C:/Users/Z6/Desktop/3DSEM/Stefan/1.AT/2.June20_v4_final-fr-with-vess2-small-408R/11.analysis-aligned/2.NP-extract/1.Labkit/3.label3/segmented-output+watershed.tif");

// duplicate stack
run("Duplicate...", "duplicate");

// select Original image, then the duplicate (suffix of -1.tif)
selectImage("segmented-output+watershed.tif");
selectImage("segmented-output+watershed-1.tif");

//run analyze pixels with the size from 2-Infinity rather than 1-Infinity
	// set the output to be the mask. 
	// This processes the whole duplicated stack
	// It retursn an inverted stack of NPs with sizes greater than 1px
run("Analyze Particles...", "size=2-Infinity show=Masks stack");

//select duplicated stack then the masked image stack with NPs greater than 1*1px
selectImage("segmented-output+watershed-1.tif");
selectImage("Mask of segmented-output+watershed-1.tif");

// Invert LUT --> after inversion, the bg is properly black and NP/foreground is properly white

//Save the stack after inverting. Need to do connected component labeling (CCL) on this stack
saveAs("Tiff", "C:/Users/Z6/Desktop/3DSEM/Stefan/1.AT/2.June20_v4_final-fr-with-vess2-small-408R/11.analysis-aligned/2.NP-extract/1.Labkit/3.label3/segmented-output+watershed_greater2.tif");


// slices to manually clear due to bad slices/staining: 12/342, 49/342, 96/342, 146/342, 229/342.

// some of these slices overlap with the slices removed during Python analysis. Copied below:
//#remove slices with bands and black damage/cropping: 6, 11, 18,  32, 48, 54, 83, 145, 227,228, 263, 305, 311
//remove_slices_list = [6, 11, 18,  32, 48, 54, 83, 102, 145, 227, 228, 263, 305, 311]


