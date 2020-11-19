//Welcome to the AUTOmated SEGMENTER Suit (AutoRadioSegmenter)
//This .ijm plugin was written by Martin Tetard (CEREGE, France)

print("Select the input core directory"); //Prints a message to ask the user for the input core directory
wait(1500);
run("Close");
dir_core = getDirectory("Select the input core Directory"); //Makes you choose the input core directory
subFolderList = getFileList(dir_core); //Gets a list of the sample folders contained within the core directory
dir_output_core = dir_core + "/Segmented images/"; //Defines the main output directory which will be created in the input directory
create_core_output = File.makeDirectory(dir_output_core); //Creates the main output folder

for (i = 0; i < subFolderList.length; i++) {
        fileList = getFileList(dir_core + subFolderList[i]); //Gets a list of the images contained within the sample folders
        dir_output_sample = dir_output_core + subFolderList[i]; //Defines the output subfolders which will be created in the main output folder
        create_sample_output = File.makeDirectory(dir_output_sample); //Creates the output subfolders corresponding to samples

        setBatchMode(true); //Replace false by true if you want to mask the image processing and thus increase its speed
        for (j = 0; j < fileList.length; j++) {
                if (endsWith(fileList[j], ".jpg")){
                        
                        open(dir_core + subFolderList[i] + fileList[j]); //Opens the original images
                        FOV_name = File.getName(fileList[j]);
                        FOV_name = replace(FOV_name, ".jpg", ""); //Removes the file extension
                        rename(FOV_name); //Renames the image without the file extension
                        run("8-bit"); //Transforms the image into an 8-bit one
                        run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel"); //Removes the predifined scale if any
                        run("Subtract Background...", "rolling=50 light sliding disable"); //Removes the blurry dots on the image background
                        setMinAndMax(0, 245); //Adjusts the contrast of the image (makes the background lighter)
                        run("Apply LUT");
                        run("Duplicate...", "title=processed"); //Duplicate the original image
                        selectWindow(FOV_name);
                        run("Invert"); //Inverts the original image
                        selectWindow("processed");
                        setThreshold(0, 200); //220 //Sets the threshold
                        setOption("BlackBackground", true);
                        run("Convert to Mask");
                        run("Options...", "iterations=1 count=1 black pad");
                        run("Close-"); //Closes opened particles
                        run("Fill Holes"); //Fills holes of particles
                        run("Gaussian Blur...", "sigma=10"); //8 Makes the image slightly blurry
                        setThreshold(60, 255);//50 //80 //Sets again the threshold
                        run("Convert to Mask");
                        run("Fill Holes"); //Fills holes of particles
                        run("Watershed Irregular Features", "erosion=1 convexity_threshold=0.94 separator_size=0-Infinity"); //0.92 Separates objets that are in contact with each other
                        run("Watershed Irregular Features", "erosion=15 convexity_threshold=0.00 separator_size=0-Infinity"); //Separates objets that are in contact with each other
                        run("Analyze Particles...", "size=5000-Infinity circularity=0.10-1.00 exclude include add"); //Performs a Particles Analysis on the image
                        selectWindow("processed");
                        close();

                        for (k = 0; k < roiManager("count"); k++) {         
                                selectWindow(FOV_name);
                                roiManager("Select", k); //Draws an ROI on the original image
                                run("Enlarge...", "enlarge=2 pixel"); //Enlarges the ROI //10
                                run("Copy");
                                List.setMeasurements;
                                WidthSel = List.getValue("Width");
                                HeightSel = List.getValue("Height");
                                        if(WidthSel > HeightSel){
                                                newImage("Squarevig", "8-bit black", WidthSel+6, WidthSel+6, 1);
                                        }
                                        else{
                                                newImage("Squarevig", "8-bit black", HeightSel+6, HeightSel+6, 1);  
                                        }
                                run("Paste");
                                //run("Enlarge...", "enlarge=5 pixel"); //Enlarges the ROI //10
                                //run("Duplicate...", "saveout"); //Segments the original image according to the ROI
                                //run("Clear Outside"); //Removes the background
                                seg_number = (k+1);
                                seg_name = FOV_name+"-"+seg_number;
                                rename(seg_name); //Renames the segmented image
                                saveAs("jpeg", dir_output_sample + seg_name); //Saves the segmented image
                                close();
                                }

                        selectWindow(FOV_name);
                        close();
                        roiManager("Reset"); //Resets the ROI manager
                        }

                }

        }

//selectWindow("ROI Manager");
//run("Close");
print("Segmentation is complete"); //Prints a successful message
wait(1000); 
print("Segmented images were saved"); 
wait(1000); 
print("ImageJ / Fiji will now close"); 
wait(3000);
run("Quit"); //Closes ImageJ
