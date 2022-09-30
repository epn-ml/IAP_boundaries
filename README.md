# IAP_boundaries
This repository is dedicated to the science case "Search for space plasmas boundary crossings", proposed by the Institute of Atmospheric Physics of Czech Academy of Sciences (IAP-CAS). The repository consists all necessary codes to read scientific data.

The repository consists MATLAB codes to process CLUSTER data
- WHISPER time-frequency spectrograms for one electric component
- FGM total magnetic field
- CIS-HIA ion density, speed, and energy spectrum

!! all codes require pre-processed .MAT files with s/c data

If user wants to retrieve data, one can use return values, 
e. g., [epoch, spectra, frequency] = clust_panel_whisper_spec(starttime, tlen, sc);
The function plot a panel and returns data.

A tutorial on how to work with our machine learning pipeline is available at epn-ml/Tutorial_IAP_Boundaries.
