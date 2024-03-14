# Stefan M. Mladjenovic 2024

import glob
import shutil
import os

from ij import IJ,ImagePlus,WindowManager,ImageStack
from ij.plugin.frame import RoiManager
from ij.plugin import Duplicator




from register_virtual_stack import Register_Virtual_Stack_MT

#@ File    (label = "Input directory", style = "directory") srcFolder

print(srcFolder)

source_parent_folder = r'%s' % srcFolder
#source_parent_folder=r"C:\Users\Z6\Desktop\3DSEM\Stefan\1.AT\2.June20_v4_final-fr-with-vess2-small-408R\5.ALIGNED\Batch-alignment1\0.source-images\5.jupyt-output"

folder_list = glob.glob(source_parent_folder + "/*/")
#folder_list = glob.glob("C:/Users/Z6/Desktop/3DSEM/Stefan/1.AT/2.June20_v4_final-fr-with-vess2-small-408R/OG-project/EM23-408_data/session_922728361/*/", recursive = True)





# shrinkage option (false)
use_shrinking_constraint = 0

p = Register_Virtual_Stack_MT.Param()
# The "maximum image size":
p.sift.maxOctaveSize = 1024
# The "inlier ratio":
p.minInlierRatio = 0.05


for i in range(len(folder_list)):
    #print(i)
    #print(folder_list[i])
    current_src_dir = r'%s' %folder_list[i]
    print(current_src_dir)
    #current_src_dir_output = os.path.join(current_src_dir, "output", "")
    current_src_dir_output = os.path.join(os.path.dirname(current_src_dir),"output","") # need to do double backslash as escape character
    print(current_src_dir_output)
    
    #
    big_vess,small_vess = glob.glob(os.path.join(current_src_dir, "*.tif")) # returns two values, first will be big_vess and second will be small_ves. Could also glob for 'big_vess' and 'small_ves'. Doesn't matter in this case
    
    #the basename is needed, not the whole path 
    big_vess_basename = os.path.basename(big_vess) 
    #small_vess_basename = os.path.basename(small_vess)
    
    #get 4 digit suffix for image
    file_name_suffix_num_based_on_folder = os.path.basename(os.path.normpath(current_src_dir))
    
    ### Do alignment 
    # source directory
    source_dir = current_src_dir
    # output directory
    target_dir = current_src_dir_output
    # transforms directory
    transf_dir = current_src_dir_output
    # reference image
    reference_name = big_vess_basename
    Register_Virtual_Stack_MT.exec(source_dir, target_dir, transf_dir, reference_name, p, use_shrinking_constraint)    
    
#note: if there are errors, then the error box needs to be closed. These images did not get registered.
# I had an error with images: 2, 19, 22, 23, 26, 31 and 32. 
	# use MosaicJ to align these 6 images manually. 
	# would be good to store error images to a log somehow and still allow the code to proceed so that user input is not needed. 
