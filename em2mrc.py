
# script converts .em files into .mrc files using the EMAN2 librar
# to run type: python em2mrc.py
ml EMAN2
import os
import EMAN2

# Define the input folder containing .em files and the output folder for .mrc files
input_folder = './'
output_folder = './mrc'

# Create the output folder if it doesn't exist
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# Loop through each .em file in the input folder
for em_file in os.listdir(input_folder):
    if em_file.endswith('.em'):
        # Construct the full file path for the .em file
        em_file_path = os.path.join(input_folder, em_file)

        # Load the .em file using EMAN2
        em_data = EMAN2.EMData(em_file_path)

        # Construct the output .mrc file path
        mrc_file_name = os.path.splitext(em_file)[0] + '.mrc'
        mrc_file_path = os.path.join(output_folder, mrc_file_name)

        # Write the data to .mrc format
        em_data.write_image(mrc_file_path)

        print(f"Converted {em_file} to {mrc_file_name}")

print("Conversion complete!")

