// Stefan M. Mladjenovic 2024

// run morpholibj with connectivity of 4 on z-stack 
// cannot use connectivity 4 on a z-stack, minimum is 6. 
// so will need to do each slice one at a time, then collect the labeled stack at the end
// get max number of each slice (highest label), then add this to the following stack

//open NP image that has been cleaned to remove 1px noise

//set to 342 z-slices rather than 342 timepoints if incorrect
//run("Properties...", "channels=1 slices=342 frames=1 pixel_width=17.000 pixel_height=17.000 voxel_depth=70.0000");



selectImage("segmented-output+watershed_greater2_good-slices.tif");

//num_slices_stack = 10;
num_slices_stack = nSlices+1;


//structure for for-loop from 
//see : https://forum.image.sc/t/how-to-apply-a-macro-on-all-the-open-windows/44375

//selectImage("3-binary+w-shed_9_segmentation-result.tif");
//selectImage("segmented-output+watershed.tif");
selectImage("segmented-output+watershed_greater2_good-slices.tif");

for (i=1;i<num_slices_stack;i++) 
{
 	if (i==1){
	// run on first slice
	run("Slice Keeper", "first=1 last=1 increment=1");
	run("Connected Components Labeling", "connectivity=4 type=float");
	
	//get maximum value
	getRawStatistics(nPixels, mean, min, max, std, histogram);
	
	//store max value as non_zero_max. this assumes that the first slice of dataset has nanoparticles (otherwise it would likely be sliced out)
	non_zero_max = max;
	//print(max);
	
	//store max value in array (number of separate NPs in the slice)
	// source: https://imagej.nih.gov/ij/macros/examples/ArrayConcatExamples.txt
	// how to append value to list
	//print("add value to end of an array");
	
	max_values = Array.concat(max_values, non_zero_max);
	//Array.print(max_values);
	
	//in the following slices, we will add the max value to all the NPs to increase the counter
		//select pixels that are not background (i.e. NP pixels) and add the value of max
		

 	}
 	
 	// for all slices after the first slice
 	else if(i>1){
 		
 		selectImage("segmented-output+watershed_greater2_good-slices.tif");
			
		run("Slice Keeper", "first=i last=i increment=1");
		run("Connected Components Labeling", "connectivity=4 type=float");
 		
 		//get maximum value of current slice
		getRawStatistics(nPixels, mean, min, max, std, histogram);
 		
	 	// there may be cases where the slice is empty as it has an artifact. In this case, save the last max value which is greater than 0. Otherwise the max value will be zero when there are two consecutive empty slices.
	 	
	 	if (max==0){
			//if max == 0, then there are no NPs on this slice. still write this max value into the array. 
			max_values = Array.concat(max_values, non_zero_max);
			//Array.print(max_values);
		}
	 	
	 	
	 	if (max!=0){
	 		//select pixels that are not background and add the value of max
			setThreshold(1, 1000000000000000000000000000000.0000); //change from lowerthresh to 1 in v4
			run("Create Selection");
			resetThreshold();
			
			// add the maximum value of previous slice to each non-bg pixel. the non-bg pixels are the current selection.
			// see: https://forum.image.sc/t/add-scalar-value-to-every-pixel/20795/2
			run("Add...", "value=non_zero_max"); 
			
			//recalculate the max value after adding the last non_zero_max value
			//get maximum value
			getRawStatistics(nPixels, mean, min, max, std, histogram);
	
			//if max is not equal to zero, then set the value of non_zero_max to max
			non_zero_max = max;
			//print(non_zero_max);
			
			//store max value in array (number of separate NPs in the slice)
			max_values = Array.concat(max_values, non_zero_max);
			//Array.print(max_values);
	
			
			//close all images that have the text 'kept stack' in the title after some text (asterisks, wildcard)
			// can do this as we go, or once at the end. probably easier to manage if we close as the macro runs
					
			
		}
		close("*kept stack");			
		print(i);
		
 	}

 
 	
	
	
}

// close the original z-stack image
selectImage("segmented-output+watershed_greater2_good-slices.tif");
close();


//put all images of labels into one stack when done
run("Images to Stack");

Array.print(max_values);

