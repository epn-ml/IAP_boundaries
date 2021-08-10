% Plot Example of bow-shock crossing for CLUSTER 1 spacecraft
% !!! the path to the top directory with .MAT files
% !!! has to be set
global caapath_matdata;
caapath_matdata = '../IAP_boundaries_data';

starttime = datenum(2002,1,21,2,22,0); % a start time
tlen = 5 * 60; % a time interval lenght in seconds
sc = 1;  % CLUSTER 1 s/c

subplot(5, 1, 1)
% WHISPER time-frequency spectrogram for one electric component
clust_panel_whisper_spec(starttime, tlen, sc);

subplot(5, 1, 2)
% FGM total magnetic field
clust_panel_fgm_mag(starttime, tlen, sc);

subplot(5, 1, 3)
% CIS-HIA ion density
clust_panel_ion_density_hiacaa(starttime, tlen, sc);

subplot(5, 1, 4)
% CIS-HIA ion velocity
clust_panel_ion_speed_hiacaa(starttime, tlen, sc);

subplot(5, 1, 5)
% CIS-HIA energy spectrum
clust_panel_cishia_spec(starttime, tlen, sc);