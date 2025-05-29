//This is macro for Fiji
//Sums frames along z-coordinates
// Run it after Delete_frames_from_particles macro
#@ File (label = "Input folder", style = "directory") inputFolder
#@ File (label = "Output folder", style = "directory") outputFolder

// Get the list of all .tif files in the input folder
fileList = getFileList(inputFolder);
setBatchMode(true); // To speed up processing

for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif")) {
        // Construct the full path of the file
        filePath = inputFolder + File.separator + fileList[i];
        
        // Debug: Print the file path to ensure it's correct
        print("Attempting to open: " + filePath);
        
        // Check if the file actually exists before attempting to open
        if (!File.exists(filePath)) {
            print("File does not exist: " + filePath);
            continue;
        }

        // Open the .tif file directly
        open(filePath);

        // Perform a Z-projection (Average Intensity Projection)
        run("Z Project...", "projection=[Sum Slices]");
        
        // Save the Z-projection in the output folder with a consistent naming convention
        outputProjectionPath = outputFolder + File.separator + replaceExtension(fileList[i], "zproject_average.tif");
        saveAs("Tiff", outputProjectionPath);

        // Close all images to free memory
        close();
    }
}

setBatchMode(false);
print("Z-Projection complete!");

// Helper function to replace the file extension
function replaceExtension(filename, newExtension) {
    dotIndex = lastIndexOf(filename, ".");
    if (dotIndex != -1) {
        return substring(filename, 0, dotIndex) + "." + newExtension;
    } else {
        return filename + "." + newExtension;
    }
}
