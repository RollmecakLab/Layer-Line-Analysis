//Fiji macro to delete frames from particles that should not contribute to FFT (black grames, frames with gold, empry frames and frames that have microtubules that are not under analysis
//To figure out frames to be removed at the beginning and end of a movie, open the movie in IMOD or fiji and examine it
//This script should be run after conversion of particles into .mrc format using em2mrc.py script
#@ File (label = "Input folder", style = "directory") inputFolder
#@ File (label = "Output folder", style = "directory") outputFolder
#@ String (label = "Frame range (e.g. 1-10)") frameRange

// Get the list of all .mrc files in the input folder
fileList = getFileList(inputFolder);
setBatchMode(true); // To speed up processing

for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".mrc")) {
        // Correct file path construction with separator
        filePath = inputFolder + File.separator + fileList[i];
        
        // Debug: Print the file path to ensure it's correct
        print("Attempting to open: " + filePath);
        
        // Check if the file actually exists before attempting to open
        if (!File.exists(filePath)) {
            print("File does not exist: " + filePath);
            continue;
        }

        // Open the .mrc file using Bio-Formats
        run("Bio-Formats Importer", "open=[" + filePath + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

        // Get the number of slices in the stack
        totalSlices = nSlices;

        // Parse the frame range entered by the user
        sliceRange = split(frameRange, "-");
        firstSlice = parseInt(sliceRange[0]);
        lastSlice = parseInt(sliceRange[1]);

        // Ensure the frame range is valid
        if (firstSlice < 1 || lastSlice > totalSlices || firstSlice > lastSlice) {
            print("Invalid frame range for " + fileList[i] + ": " + frameRange);
            close();
            continue;
        }

        // Create the substack based on the frame range
        run("Make Substack...", "slices=" + firstSlice + "-" + lastSlice);
        
        // Save the substack in the output folder as a .tif file
        outputFilePath = outputFolder + File.separator + replaceExtension(fileList[i], "tif");
        saveAs("Tiff", outputFilePath);

        // Close the current image to free memory
        close();
    }
}

setBatchMode(false);
print("Processing complete!");

// Helper function to replace the file extension
function replaceExtension(filename, newExtension) {
    dotIndex = lastIndexOf(filename, ".");
    if (dotIndex != -1) {
        return substring(filename, 0, dotIndex) + "." + newExtension;
    } else {
        return filename + "." + newExtension;
    }
}
