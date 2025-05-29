//This Fiji macro rotates microtubule align it vertically
//When running this macro, draw a straight line along the microtubule long axis for one particle to define rotation for the rest of the particles
//Run this macro after Project_along_z macro

// Select the input folder containing TIFF files
inputFolder = getDirectory("Select the folder containing TIFF files:");
if (inputFolder == "") {
    exit("No input folder selected. Exiting.");
}

// Select the output folder to save the rotated images
outputFolder = getDirectory("Select the folder to save the rotated images:");
if (outputFolder == "") {
    exit("No output folder selected. Exiting.");
}

// Get the list of TIFF files in the input folder
fileList = getFileList(inputFolder);
if (fileList.length == 0) {
    exit("No TIFF files found in the selected input folder.");
}

// Open the first image in the folder to define the rotation angle
firstImagePath = inputFolder + fileList[0];
open(firstImagePath);
waitForUser("Draw a straight line on the image and click OK to calculate the rotation angle.");

// Get the coordinates of the drawn line selection
getSelectionCoordinates(xPoints, yPoints);  // Store coordinates in xPoints and yPoints arrays

// Ensure that the ROI is a line with exactly 2 points
if (xPoints.length != 2 || yPoints.length != 2) {
    exit("No valid straight line ROI found. Draw a straight line to define the rotation angle.");
}

// Calculate the angle of the line relative to the x-axis
x1 = xPoints[0];
y1 = yPoints[0];
x2 = xPoints[1];
y2 = yPoints[1];
dx = x2 - x1;
dy = y2 - y1;

// Use the atan2() function to get the angle in radians and convert to degrees
radians = atan2(dy, dx);
angle = -radians * (180 / PI);  // Convert radians to degrees

// Correct the angle by subtracting 90 degrees to align the filament vertically
angle = angle - 90;
print("Corrected rotation angle: " + angle + " degrees.");

// Calculate the average gray value of the image to fill the black edges
run("Select All");
getStatistics(area, mean, min, max, stdDev);
averageGray = mean;  // Use the mean intensity as the fill value

// Close the first image after reading the angle and calculating the average gray value
close();

// Process and rotate all the other TIFF images in the input folder
for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif") || endsWith(fileList[i], ".tiff")) {
        // Open the image
        imagePath = inputFolder + fileList[i];
        open(imagePath);
        
        // Apply rotation to align the image using the corrected angle
        run("Rotate...", "angle=" + angle + " grid=1 interpolation=Bilinear stack");

        // Fill the black edges with the average gray value
        setBackgroundColor(averageGray, averageGray, averageGray);
        run("Canvas Size...", "width=" + getWidth() + " height=" + getHeight() + " position=Center");

        // Save the rotated image in the output folder with the same name
        outputFilePath = outputFolder + fileList[i];
        saveAs("Tiff", outputFilePath);
        
        // Close the rotated image to free up memory
        close();
    }
}

print("Rotation applied to all images in the input folder. Processed images saved to: " + outputFolder);
