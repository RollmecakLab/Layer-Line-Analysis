// Select the input folder containing TIFF files
inputFolder = getDirectory("Select the folder containing TIFF images:");
if (inputFolder == "") {
    exit("No input folder selected. Exiting.");
}

// Select the output folder to save the cropped images
outputFolder = getDirectory("Select the folder to save the cropped images:");
if (outputFolder == "") {
    exit("No output folder selected. Exiting.");
}

// Get the list of TIFF files in the input folder
fileList = getFileList(inputFolder);
if (fileList.length == 0) {
    exit("No TIFF files found in the selected input folder.");
}

// Define the crop dimensions
cropWidth = 430;
cropHeight = 430;

// Process each image in the folder
for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif") || endsWith(fileList[i], ".tiff")) {
        // Open the image
        open(inputFolder + fileList[i]);

        // Get the dimensions of the current image
        originalWidth = getWidth();
        originalHeight = getHeight();

        // Ensure the image is 500x500 before cropping
        if (originalWidth == 500 && originalHeight == 500) {
            // Calculate the top-left corner for the 460x460 crop region
            startX = (originalWidth - cropWidth) / 2;  // 20 pixels from the left
            startY = (originalHeight - cropHeight) / 2;  // 20 pixels from the top

            // Perform the crop
            makeRectangle(startX, startY, cropWidth, cropHeight);
            run("Crop");

            // Save the cropped image to the output folder with the same name
            saveAs("Tiff", outputFolder + fileList[i]);

            // Close the image to free up memory
            close();
        } else {
            print("Skipping " + fileList[i] + " (not a 500x500 image)");
            close();
        }
    }
}

print("All images cropped and saved in: " + outputFolder);
