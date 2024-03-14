# Overview
This folder contains the files used to process the electron microscopy dataset for the publication Three-Dimensional Electron Microscopy for Nanoparticle Tumour Analysis by Mladjenovic et al. 

Below is a description of how the electron microscopy (EM) image stacks are processed. 



## 1.Pre-processing

1.1. There are two vessels that merge in the tumour nanoparticle 3D EM dataset. One is a larger vessel and one is a smaller vessel. Each vessel was imaged separately on each tissue section i.e. two images for each tissue section, one for each vessel. Once the two vessels merged into one vessel, only one image was captured for each tissue section.

1.2. For tissue sections with two separated vessels, the two sets of images need to be aligned with each other. The result will be one larger image made of the two images from the same tissue section.

1.3. The .tif images for the two separated vessels are used to form two image stacks via FIJI. Since the dimensions are slightly different by a few pixels depending on how the field of view was rotated during imaging, the images were opened as a virtual stack (in FIJI: File -> Import -> Image Sequence... -> check "Use virtual stack")

1.4. The virtual stacks of the two vessels are both appropriately cropped such that there are black pixels padding the images. 

1.5. Now the two image stacks are saved in FIJI to two new folders  (i.e. 2.large-vess and 3.small-vess). Each section of the stack is saved as a separate image with a 4-digit suffix. For example, the small and large vessel and section 1 is saved as small_vess_0000.tif and big_vess_0000.tif respectively. 

1.6. Now Python was used to copy the two images from the same tissue section into a new folder. There is a separate folder created for each tissue section (i.e. section 1 is in folder 0000 and contains small_vess_0000.tif and big_vess_0000.tif, section 2 is in folder 0001 and contains small_vess_0001.tif and big_vess_0001.tif ). This is done with the file move-files-with-num-suffix.ipynb.

1.7. Now the two images on each section are aligned with each other using a Jython script in FIJI (Jython-get-dirs-align.py). The code aligns the two images with each other using the Register Virtual Stack Slices plugin. Now the two aligned images on the same section are aligned and on separate z-slices in FIJI.

1.8. To flatten the two images on the same tissue section into one image, we use Z-Projection. Then we save the single-channel image of the two overlapping vessels and save them using the following IJM script in FIJI: Z-project-all-imgs-save-close.ijm.

1.9. For cases where the two images on the same tissue section were not able to be aligned with each other, they were processed semi-automatically in MosaicJ. The result of the MosaicJ alignment has white blackground pixels instead of black background pixels. Thus the white pixels were replaced with white pixels using the following IJM script in FIJI: replace-pixel-value-all-open-imgs.ijm.

1.10. Next the stack of images made of the two vessels on one tissue sections were combined with the image stack of the merged vessels on one tissue sections. This is the completed dataset before alignment.



## 2.Alignment

2.1 The tumour nanoparticles 3D EM dataset was padded with black pixels in FIJI. Padding was done before alignment so that regions of the imaged tissue would not be lost if the images were rotated in a way that they went beyond the image canvas during alignment. 

2.2. Regions of the image stack were manually masked out with black pixels in FIJI where there were artifacts that could 'confuse' the alignment algorithm.

2.3. The images were roughly affine aligned with each other using the SIFT algorithm in FIJI (Plugins -> Registration -> Linear Alignment with SIFT).

2.4. The images were then elastically aligned with each other using the code described here: https://github.com/nano6626/EM-Stitching-and-Alignment/tree/main/Project%20Specific%20Scripts/Mladjenovic_et_al



## 3.Annotation

3.1. The cells in the aligned EM stack images were then annotated using Microscopy Image Browser via MatLab

3.2. The nanoparticles in the aligned EM stack images were then annotated/segmented using LabKit in FIJI. 

3.2.1. The results of the nanoparticle segmentation was cleaned by removing noise that were only 1 pixel large. This was done in FIJI using the following IJM script: keep-larger-than-1px.ijm.

3.2.2. Each nanoparticle was isolated from the dataset by using connected component analysis in FIJI using the following IJM script: connected-component-analysis.ijm. 



## 4.Analysis

4.1. Analysis is done using Python as described in the Jupyter Notebook file 3D-EM-analysis.ipynb.

4.1.2. For distance calculations, the 3D Euclidean distance is calculated in FIJI with 3D ImageJ Suite using the file 3D-EDT-3D-suite.ijm



*****************************************************

LICENSE

Copyright 2024 Mladjenovic et al.

This software license is the 2-clause BSD license plus a third clause that prohibits redistribution and use for commercial purposes without further permission from the authors of this work (Mladjenovic et al).

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Redistributions and use for commercial purposes are not permitted without the written permission of the authors of this work (Mladjenovic et al). For purposes of this license, commercial purposes are the incorporation of the software into anything for which you will charge fees or other compensation or use of the software to perform a commercial service for a third party.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
