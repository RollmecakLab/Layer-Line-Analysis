// Fiji Macro: Calculate FFT for All TIFF Images in a Folder
//Run this macro after macro called set_pix400_background

// Prompt the user to select the input and output folders
inputFolder = getDirectory("Choose the folder with TIFF images:");
outputFolder = getDirectory("Choose the output folder for FFT images:");

// Get a list of all TIFF files in the folder
fileList = getFileList(inputFolder);

// Check if there are any TIFF files to process
if (fileList.length == 0) {
    showMessage("Error", "No TIFF files found in the selected folder.");
    exit();
}

// Loop through all TIFF files in the input folder
for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif")) {
        // Open each TIFF file
        open(inputFolder + fileList[i]);
        imageTitle = getTitle();

        // Calculate FFT
        run("FFT");

        // Save the FFT result with a modified filename in the output folder
        fftTitle = replaceExtension(imageTitle, "_FFT.tif");
        saveAs("Tiff", outputFolder + fftTitle);

        // Close the images after saving to free memory
        close(); // Closes the FFT result
        selectWindow(imageTitle);
        close(); // Closes the original image
    }
}

// Notify the user that processing is complete
showMessage("Processing Complete", "FFT has been calculated for all TIFF images in the folder.");

// Helper function to replace the file extension with "_FFT.tif"
function replaceExtension(filename, suffix) {
    dotIndex = lastIndexOf(filename, ".");
    if (dotIndex != -1) {
        return substring(filename, 0, dotIndex) + suffix;
    } else {
        return filename + suffix;
    }
}
