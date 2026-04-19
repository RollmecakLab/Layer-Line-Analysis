# Layer-Line-Analysis
Scripts to analyze microtubule lattice spacing in Fourier space 


Reconstruct the tomogram using IMOD or AreTomo protocols.
Trace each microtubule in Dynamo using a filament model (crop along the axis).
Extract particles from each microtubule into boxes slightly larger than the microtubule diameter (e.g., ~400 Å).
Average the extracted particles to generate an initial 3D reference.
Align particles to the reference using Dynamo’s dcp command (one or two iterations are typically sufficient).
Inspect aligned particles in Dynamo’s dGallery GUI and select non-overlapping, well-aligned particles that cover the full microtubule length.
Re-extract selected particles using dtcrop into larger boxes (~2000 Å; approximately 21–26 dimers).

Proceed in Fiji:

Remove frames that do not contain biological material (e.g., first and last N frames) using Delete_frames_from_particles.ijm.
Sum the remaining frames using Project_along_z.ijm.
Rotate microtubule particles to a vertical orientation using Rotate_sums.ijm.
Crop the microtubule region using crop_out_MT.ijm.
Compute the Fourier transform of each summed particle using Calculate_FFT.ijm.
Sum all FFT images using sum_FFTs.py.
Open the summed FFT, draw a straight line from the meridian to the ~40 Å layer line, and plot the intensity profile (Command + K).
Measure the distance between the meridian and the ~40 Å layer line peak, and calculate the lattice spacing.
