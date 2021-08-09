% Plot Example

starttime = datenum(2002,1,21,2,22,0);
tlen = 5 * 60;
sc = 1; 

subplot(5, 1, 1)
clust_panel_whisper_spec(starttime, tlen, sc);

subplot(5, 1, 2)
clust_panel_fgm_mag(starttime, tlen, sc);

subplot(5, 1, 3)
clust_panel_ion_density_hiacaa(starttime, tlen, sc);

subplot(5, 1, 4)
clust_panel_ion_speed_hiacaa(starttime, tlen, sc);

subplot(5, 1, 5)
clust_panel_cishia_spec(starttime, tlen, sc);