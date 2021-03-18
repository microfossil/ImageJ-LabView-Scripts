//Welcome to the Morphometrics on Foraminifera (MorFo) Plugin
//This .ijm plugin was written by Martin Tetard (CEREGE, France)

print("Select the input directory"); //Prints a message to ask for the input core directory
wait(2000);
run("Close");
dir1 = getDirectory("input directory"); //This command lets the user choose the input directory where the images are located
list = getFileList(dir1);
dir2 = dir1 + "/Original resized images/" //These commands are used to define three output directories will be created in the input directory
dir3 = dir1 + "/Processed images/"
dir4 = dir1 + "/Results/"

ok = File.makeDirectory(dir2) //These commands are used to create output directories
ok = File.makeDirectory(dir3)
ok = File.makeDirectory(dir4)

table = "[Combined Results]"; //This command creates a table that will summarise the results for every specimen and every sample
run("Table...", "name="+table+" width=450 height=500");

results_merge="";

pixel = getNumber("In order to set a scale, enter a known distance in pixel", 570);
micrometre = getNumber("then enter its corresponding distance in micrometre", 10000);

setBatchMode(false); //Replace false by true if you want to mask the image processing and thus increase its speed
for (k = 0; k<list.length; k++) { 
        showProgress(k+1, list.length); 
        open(dir1+list[k]);
        t=getTitle();
        run("Size...", "width=1000 height=1000 constrain average interpolation=Bilinear"); //This command resizes the original image
        run("Set Scale...", "distance=pixel known=micrometre unit=µm");
        saveAs("Tiff",dir2 + t); //This command saves the resized original image in the "Original resized images folder"
        run("8-bit"); //This command transforms the image into an 8-bit one
        //setThreshold(100, 255); //220 //Sets the threshold
        //setOption("BlackBackground", true);
        //run("Convert to Mask");
        setOption("BlackBackground", true); //This command ensures that the background is black and not considered as the object to analyse
        run("Make Binary", "method=Default background=Default calculate black"); //This commande binarise the image
        run("Set Measurements...", "area fit shape display redirect=None decimal=3"); //This command precise which measurements should be done
        run("Watershed Irregular Features", "erosion=1 convexity_threshold=0.95 stack"); //This command is used to separate specimens that are in contact with each other (Biovoxxel plugin is required)
        t2 = replace(t, ".tif", "");
        rename(t2);
        run("Analyze Particles...", "size=12500-Infinity circularity=0.30-1.00 display exclude clear include summarize"); //This command is used to perform the specified measurements on each specimen of the image
        String.copyResults; 
        resultati=String.paste;   
        results_merge=results_merge+resultati;
        //ok = File.delete(dir1 + t); //This command is used to delete the original (un-resized) image, remove it if you want to keep it
        selectWindow(t2);
        saveAs("Tiff",dir3 + t); //This command is used to save the processed image into the "Processed images" folder
        close();
}

print(table,String.getResultsHeadings); 
print(table,results_merge);

selectWindow("Combined Results");
saveAs("Specimens_results", dir4 + "Specimens_results.csv"); //This command is used to save the morphometric measurements for every specimen
run("Close");

selectWindow("Results"); 
run("Close");

selectWindow("Summary");
saveAs("Samples_results", dir4 + "Samples_results.csv"); //This command is used to save the average morphometric measurements for every sample
run("Close");

print("Morphometric analysis is complete");
wait(1000);
//print("Original images were deleted");
//wait(1000);
print("Resized images were saved into the Original resized images folder");
wait(1000);
print("Processed images were saved into the Processed images folder");
wait(1000);
print("Results were saved into the Results folder");
wait(1000);
print("ImageJ / Fiji will now close");

wait(2000);
run("Quit"); //This command is used to close the ImageJ / Fiji distribution