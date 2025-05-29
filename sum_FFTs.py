# This script sums FFT images in a folder
# run it as : python sum_FFTs.py
import os
import numpy as np
from PIL import Image

def sum_tiff_images(input_folder, output_file):
    # Initialize the sum as None
    sum_image = None
    
    # List all files in the input folder
    tiff_files = [f for f in os.listdir(input_folder) if f.endswith('.tif') or f.endswith('.tiff')]
    
    # Loop through each TIFF file in the folder
    for i, tiff_file in enumerate(tiff_files):
        file_path = os.path.join(input_folder, tiff_file)
        print(f"Processing file: {file_path}")
        
        # Open the current TIFF file
        with Image.open(file_path) as img:
            img_array = np.array(img, dtype=np.float32)  # Convert image to a float32 NumPy array

            if sum_image is None:
                # Initialize the sum image if it's the first file
                sum_image = np.zeros_like(img_array, dtype=np.float32)
            
            # Add the current image to the running sum
            sum_image += img_array

    # Clip the result to avoid overflow
    sum_image = np.clip(sum_image, 0, np.finfo(np.float32).max)

    # Convert the sum image back to an image object
    summed_image = Image.fromarray(sum_image.astype(np.float32))

    # Save the summed image as a 32-bit TIFF file
    summed_image.save(output_file, format='TIFF', bits=32)
    print(f"Summed image saved to {output_file}")

# Example usage
input_folder = './'  # Replace with the path to your TIFF folder
output_file = './summed_imageFFT.tif'  # Replace with the desired output path
sum_tiff_images(input_folder, output_file)

