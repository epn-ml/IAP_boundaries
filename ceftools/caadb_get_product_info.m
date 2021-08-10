function [pstr, pnum, ppath, multisc] = caadb_get_product_info(product)

% out = caadb_get_product_info(product)
%

numprod = 91;
prods = cell(1,numprod);
paths = cell(1,numprod);
notes = cell(1,numprod);

prods{1} = 'fgm_5vps';
paths{1} = 'cluster/fgm/5vps';
notes{1}  = 'Cluster FGM magnetic field 5 vectors/sec';
multi(1) = 1;

prods{2} = 'fgm_spin';
paths{2} = 'cluster/fgm/spin';
notes{2}  = 'Cluster FGM magnetic field - spin res.';
multi(2) = 1;

prods{3} = 'ace_mag16s';
paths{3} = 'ace/mag16s';
notes{3}  = 'ACE magnetic field data (16 sec res.)';
multi(3) = 0;

prods{4} = 'ace_swepam64s';
paths{4} = 'ace/swepam64s';
notes{4}  = 'ACE SWEPAM particle data (64 sec res.)';
multi(4) = 0;

prods{5} = 'cis_pp';
paths{5} = 'cluster/cis/pp';
notes{5}  = 'Cluster CIS prime parameter data (from CDF)';
multi(5) = 1;

prods{6} = 'cluster_aux';
paths{6} = 'cluster/aux';
notes{6}  = 'Cluster AUX prime parameter data (from CDF)';
multi(6) = 0;

prods{7} = 'themis_onboard_mom_electrons';
paths{7} = 'themis/mom/electrons';
notes{7} = 'THEMIS ESA electron onboard momens (MOM product)';
multi(7) = 1;

%prods{7} = 'themis_esa_moments';
%paths{7} = 'themis/esa/moments';
%notes{7}  = 'THEMIS Electrostatic analyzer L3 moments';
%multi(7) = 1;

prods{8} = 'themis_fgml';
paths{8} = 'themis/fgm/lo';
notes{8}  = 'THEMIS Magnetic field data (low rate - typically 4 Hz)';
multi(8) = 1;

prods{9} = 'stereo_mag';
paths{9} = 'stereo/mag';
notes{9}  = 'STEREO IMPACT magnetic field data 8Hz';
multi(9) = 1;

prods{10} = 'stereo_posgse';
paths{10} = 'stereo/posgse';
notes{10}  = 'STEREO GSE position';
multi(10) = 1;

prods{11} = 'ds1_aux';
paths{11} = 'ds1/aux';
notes{11}  = 'Double Star T1 position';
multi(11) = 0;

prods{12} = 'ds2_aux';
paths{12} = 'ds2/aux';
notes{12}  = 'Double Star T2 position';
multi(12) = 0;

prods{13} = 'whisper_natural';
paths{13} = 'cluster/whisper/natural';
notes{13}  = 'Cluster electric field spectra from WHISPER';
multi(13) = 1;

prods{14} = 'whisper_density';
paths{14} = 'cluster/whisper/density';
notes{14}  = 'Cluster electron density from WHISPER';
multi(14) = 1;

prods{15} = 'peace_pitch_spin_psd';
paths{15} = 'cluster/peace/pitch_spin_psd';
notes{15}  = 'Cluster PEACE el. pitch angle dist. (spin res., rebinned, PITCH_SPIN_PSD)';
multi(15) = 1;

prods{16} = 'peace_moments';
paths{16} = 'cluster/peace/moments';
notes{16}  = 'Cluster electron dist. moments from PEACE (spin res.)';
multi(16) = 1;

prods{17} = 'peace_pad_marl_psd';
paths{17} = 'cluster/peace/pad_marl_psd';
notes{17}  = 'Cluster PEACE LEEA pitch angle el. dist. (CPADMARL product, calibrated PSD)';
multi(17) = 1;

prods{18} = 'peace_pad_marh_psd';
paths{18} = 'cluster/peace/pad_marh_psd';
notes{18}  = 'Cluster PEACE HEEA pitch angle el. dist. (CPADMARH product, calibrated PSD)';
multi(18) = 1;

prods{19} = 'peace_pad_marl_cnt';
paths{19} = 'cluster/peace/pad_marl_cnt';
notes{19}  = 'Cluster PEACE LEEA pitch angle el. dist. (CPADMARL product, raw counts)';
multi(19) = 1;

prods{20} = 'peace_pad_marh_cnt';
paths{20} = 'cluster/peace/pad_marh_cnt';
notes{20}  = 'Cluster PEACE HEEA pitch angle el. dist. (CPADMARH product, raw counts)';
multi(20) = 1;

prods{21} = 'efw_l2_e';
paths{21} = 'cluster/efw/l2_e';
notes{21}  = 'Cluster EFW despun data in ISR2 (25 SPS)';
multi(21) = 1;

prods{22} = 'efw_l2_egse';
paths{22} = 'cluster/efw/l2_egse';
notes{22}  = 'Cluster EFW 3D data in GSE (25 SPS)';
multi(22) = 1;

prods{23} = 'efw_l2_einert';
paths{23} = 'cluster/efw/l2_einert';
notes{23}  = 'Cluster EFW data in ISR2 with subtracted VxB field (25 SPS)';
multi(23) = 1;

prods{24} = 'efw_l2_vgse';
paths{24} = 'cluster/efw/l2_vgse';
notes{24}  = 'Cluster EFW ExB drift velocity (25 SPS)';
multi(24) = 1;

prods{25} = 'efw_l2_pot';
paths{25} = 'cluster/efw/l2_pot';
notes{25} = 'Cluster EFW spacecrafr potential in V (5 SPS)';
multi(25) = 1;

prods{26} = 'themis_aux';
paths{26} = 'themis/aux';
notes{26}  = 'THEMIS orbit data (postion, velocity in GSE)';
multi(26) = 1;

prods{27} = 'staff_sc_lbr_spec';
paths{27} = 'cluster/staff_sc/lbr_spec';
notes{27} = 'Cluster STAFF waveform (normal mode, combined E & B) special = not from CAA';
multi(27) = 1;

prods{28} = 'staff_sc_hbr_spec';
paths{28} = 'cluster/staff_sc/hbr_spec';
notes{28} = 'Cluster STAFF waveform (burst mode, combined E & B) special = not from CAA';
multi(28) = 1;

prods{29} = 'efw_l2_e3dinert';
paths{29} = 'cluster/efw/l2_e3dinert';
notes{29} = 'Cluster EFW 3D e-field potential in ISR2 with subtrected VxB';
multi(29) = 1;

prods{30} = 'whisper_energy';
paths{30} = 'cluster/whisper/energy';
notes{30} = 'Cluster Whisper high-resolution wavefrom energy (about 5 VPS)';
multi(30) = 1;

prods{31} = 'themis_fgmh';
paths{31} = 'themis/fgm/hi';
notes{31}  = 'THEMIS Magnetic field data (high rate - usually 128 Hz)';
multi(31) = 1;

prods{32} = 'themis_fgms';
paths{32} = 'themis/fgm/sp';
notes{32}  = 'THEMIS Magnetic field data (spin rate - usually 3 sec)';
multi(32) = 1;

prods{33} = 'whisper_sounding_times';
paths{33} = 'cluster/whisper/sounding_times';
notes{33} = 'Cluster Whisper sounding intervals';
multi(33) = 1;

prods{34} = 'cishia_1dspec_hs_pef';
paths{34} = 'cluster/cis/hia_spec1d_hs_pef';
notes{34} = 'Cluster CIS HIA 1D energy spectrograms (particle energy flux - high sensitivity)';
multi(34) = 1;

prods{35} = 'cishia_1dspec_ls_pef';
paths{35} = 'cluster/cis/hia_spec1d_ls_pef';
notes{35} = 'Cluster CIS HIA 1D energy spectrograms (particle energy flux - low sensitivity)';
multi(35) = 1;

prods{36} = 'themis_esa_ispecf';
paths{36} = 'themis/esa/ispecf';
notes{36} = 'THEMIS ESA ion spectrograms (full res)';
multi(36) = 1;

prods{37} = 'themis_esa_ispecr';
paths{37} = 'themis/esa/ispecr';
notes{37} = 'THEMIS ESA ion spectrograms (reduced resolution)';
multi(37) = 1;

prods{38} = 'themis_esa_ispecb';
paths{38} = 'themis/esa/ispecb';
notes{38} = 'THEMIS ESA ion spectrograms (burst mode)';
multi(38) = 1;

prods{39} = 'cishia_pad_pf';
paths{39} = 'cluster/cis/hia_pad_pf';
notes{39} = 'Cluster CIS HIA pitch angle distributions (particle flux - high sensitivity)';
multi(39) = 1;

prods{40} = 'cishia_3dmaghs_psd';
paths{40} = 'cluster/cis/hia_3dmaghs_psd';
notes{40} = 'Cluster CIS HIA 3D PSD distributions (high sensitivty, mag. modes)';
multi(40) = 1;

prods{41} = 'cishia_3dmaghs_cps';
paths{41} = 'cluster/cis/hia_3dmaghs_cps';
notes{41} = 'Cluster CIS HIA 3D distributions in counts per second (high sensitivty, mag. modes)';
multi(41) = 1;

prods{42} = 'cishia_3dmaghs_raw';
paths{42} = 'cluster/cis/hia_3dmaghs_raw';
notes{42} = 'Cluster CIS HIA 3D distributions in raw counts (high sensitivty, mag. modes)';
multi(42) = 1;

prods{43} = 'cishia_onboard_mom';
paths{43} = 'cluster/cis/hia_onboard_mom';
notes{43} = 'Cluster CIS HIA onboard moments (CAA)';
multi(43) = 1;

prods{44} = 'ds1_fgm_pp';
paths{44} = 'ds1/fgm_pp';
notes{44}  = 'Double Star TC1 FGM data (PP - spin resolution)';
multi(44) = 0;

prods{45} = 'ds1_hia_moments_pp';
paths{45} = 'ds1/hia_moments_pp';
notes{45}  = 'Double Star TC1 HIA ion moments (PP)';
multi(45) = 0;

prods{46} = 'themis_onboard_mom_ions';
paths{46} = 'themis/mom/ions';
notes{46} = 'THEMIS ESA ion onboard momens (MOM product)';
multi(46) = 1;

prods{47} = 'peace_pitch_spin_def';
paths{47} = 'cluster/peace/pitch_spin_def';
notes{47} = 'Cluster PEACE el. pitch angle dist. (diff. en. flux, PITCH_SPIN_PSD)';
multi(47) = 1;

prods{48} = 'helios_e5a_spectra';
paths{48} = 'helios/e5spectra';
notes{48} = 'Helios U. Iowa wave experiment E5A';
multi(48) = 1;

prods{49} = 'helios_merged_40s';
paths{49} = 'helios/merged40s';
notes{49} = 'Helios 40s merged data (aux, B, ion moments)';
multi(49) = 1;

prods{50} = 'helios_merged_1hour';
paths{50} = 'helios/merged_1hour';
notes{50} = 'Helios 1 hour merged data (aux, B, ion moments)';
multi(50) = 1;

prods{51} = 'omni_1min';
paths{51} = 'omni/omni2_1min';
notes{51} = 'OMNI 2 solar wind parameters propagated to BS (1 min resolution)';
multi(51) = 0;

prods{52} = 'ds1_fgm_hires';
paths{52} = 'ds1/fgm_hires';
notes{52} = 'Double Star TC1 FGM data (high resolution)';
multi(52) = 0;

prods{53} = 'peace_3drl_psd';
paths{53} = 'cluster/peace/3drl_psd';
notes{53} = 'Cluster PEACE 3D reduced distributions LEEA sensor (PSD). The PEA_3DRL_PSD product.';
multi(53) = 1;

prods{54} = 'peace_3drl_cnt';
paths{54} = 'cluster/peace/3drl_cnt';
notes{54} = 'Cluster PEACE 3D reduced distributions LEEA sensor (counts). The PEA_3DRL_cnt product.';
multi(54) = 1;

prods{55} = 'peace_3drh_psd';
paths{55} = 'cluster/peace/3drh_psd';
notes{55} = 'Cluster PEACE 3D reduced distributions HEEA sensor (PSD). The PEA_3DRH_PSD product.';
multi(55) = 1;

prods{56} = 'peace_3drh_cnt';
paths{56} = 'cluster/peace/3drh_cnt';
notes{56} = 'Cluster PEACE 3D reduced distributions HEEA sensor (counts). The PEA_3DRH_cnt product.';
multi(56) = 1;

prods{57} = 'fgm_full';
paths{57} = 'cluster/fgm/full';
notes{57} = 'Full resolution cluster FGM data (22.5 or 64 Hz)';
multi(57) = 1;

prods{58} = 'peace_3dxph_psd';
paths{58} = 'cluster/peace/3dxph_psd';
notes{58} = 'Cluster PEACE 3D extended (BM1) distributions HEEA sensor (PSD). The PEA_3DXPH_PSD product.';
multi(58) = 1;

prods{59} = 'peace_3dxph_cnt';
paths{59} = 'cluster/peace/3dxph_cnt';
notes{59} = 'Cluster PEACE 3D extended (BM1) distributions HEEA sensor (counts). The PEA_3DXPH_cnts product.';
multi(59) = 1;

prods{60} = 'peace_3dxpl_psd';
paths{60} = 'cluster/peace/3dxpl_psd';
notes{60} = 'Cluster PEACE 3D extended (BM1) distributions HEEA sensor (PSD). The PEA_3DXPL_PSD product.';
multi(60) = 1;

prods{61} = 'peace_3dxpl_cnt';
paths{61} = 'cluster/peace/3dxpl_cnt';
notes{61} = 'Cluster PEACE 3D extended (BM1) distributions LEEA sensor (counts). The PEA_3DXPL_cnts product.';
multi(61) = 1;

prods{62} = 'wbd_waveform';
paths{62} = 'cluster/wbd/waveform';
notes{62} = 'Cluster WBD waveform data conveted from CDF.';
multi(62) = 1;

prods{63} = 'dwp_corr_stepped';
paths{63} = 'cluster/dwp/corr_st';
notes{63} = 'Cluster DWP auto-correlation function (stepped energy)';
multi(63) = 1;

prods{64} = 'dwp_corr_fixed';
paths{64} = 'cluster/dwp/corr_fx';
notes{64} = 'Cluster DWP auto-correlation function (fixed energy)';
multi(64) = 1;

prods{65} = 'cas_ephemeris';
paths{65} = 'cassini/ephemeris';
notes{65} = 'Cassini Ephemeris in KSO and KSM';
multi(65) = 0;

prods{66} = 'cas_fgm';
paths{66} = 'cassini/fgm';
notes{66} = 'Cassini Fluxgate magnetometer data in KSO, 1s cadence';
multi(66) = 0;

prods{67} = 'cas_wbr10';
paths{67} = 'cassini_wbr10';
notes{67} = 'Cassini 10-kHz Wideband waveforms';
multi(67) = 0;

prods{68} = 'edi_aedc';
paths{68} = 'cluster/edi/aedc';
notes{68} = 'Cluster EDI ambient mode data (AEDC - corrected)';
multi(68) = 1;

prods{69} = 'staff_sa_sm';
paths{69} = 'cluster/staff_sa/sm';
notes{69} = 'Cluster STAFF-SA spectral matrix';
multi(69) = 1;

prods{70} = 'staff_sa_psd';
paths{70} = 'cluster/staff_sa/psd';
notes{70} = 'Cluster STAFF-SA spectrum';
multi(70) = 1;

prods{71} = 'ds1_cor_ts';
paths{71} = 'ds1/cor_ts';
notes{71} = 'Double Star T1 DWP correlator time series';
multi(71) = 0;

prods{72} = 'peace_pitch_3dxh_psd';
paths{72} = 'cluster/peace/pitch_3dxh_psd';
notes{72} = 'Cluster PEACE 3D HEEA sensor pitch angle distribution (PSD). The PEA_PITCH_3DXH_PSD product.';
multi(72) = 1;

prods{73} = 'peace_pitch_full_psd';
paths{73} = 'cluster/peace/pitch_full_psd';
notes{73} = 'Cluster PEACE full resolution pitch angle data. The PEA_PITCH_FULL_PSD product.';
multi(73) = 1;

prods{74} = 'peace_pitch_3drh_psd';
paths{74} = 'cluster/peace/pitch_3drh_psd';
notes{74} = 'Cluster PEACE 3D HEEA sensor pitch angle distribution (PSD). The PEA_PITCH_3DRH_PSD product.';
multi(74) = 1;

prods{75} = 'cishia_3dswls_psd';
paths{75} = 'cluster/cis/hia_3dswls_psd';
notes{75} = 'Cluster CIS HIA 3D PSD distributions (low sensitivty, sw modes)';
multi(75) = 1;

prods{76} = 'cishia_3dswls_cps';
paths{76} = 'cluster/cis/hia_3dswls_cps';
notes{76} = 'Cluster CIS HIA 3D distributions in counts per second (low sensitivty, sw modes)';
multi(76) = 1;

prods{77} = 'cishia_3dswls_raw';
paths{77} = 'cluster/cis/hia_3dswls_raw';
notes{77} = 'Cluster CIS HIA 3D distributions in raw counts (low sensitivty, sw modes)';
multi(77) = 1;

prods{78} = 'codif_1dspec_h1_pef';
paths{78} = 'cluster/cis/codif_spec1d_h1_pef';
notes{78} = 'Cluster CIS CODIF 1D H+ energy spectrograms (particle energy flux)';
multi(78) = 1;

prods{79} = 'codif_moments_h1_ls';
paths{79} = 'cluster/cis/codif_moments_h1_ls';
notes{79} = 'Cluster CIS CODIF H+ moments (low sensitivity)';
multi(79) = 1;

prods{80} = 'codif_moments_h1_hs';
paths{80} = 'cluster/cis/codif_moments_h1_hs';
notes{80} = 'Cluster CIS CODIF H+ moments (high sensitivity)';
multi(80) = 1;

prods{81} = 'solo_mag_rtn';
paths{81} = 'solo/mag/normal';
notes{81} = 'SolO MAG data (L2) in normal mode (8 Hz) and RTN coordinate system';
multi(81) = 0;

prods{82} = 'solo_mag_srf';
paths{82} = 'solo/mag/normal';
notes{82} = 'SolO MAG data (L2) in normal mode (8 Hz) and SRF coordinate system';
multi(82) = 0;

prods{83} = 'solo_aux';
paths{83} = 'solo/aux';
notes{83} = 'SolO AUX data from the flown SPICE kernel';
multi(83) = 0;

prods{84} = 'solo_rpw_tnr';
paths{84} = 'solo/rpw/tnrhfr';
notes{84} = 'SolO RPW TNR data (L2)';
multi(84) = 0;

prods{85} = 'solo_rpw_tds_mamp';
paths{85} = 'solo/rpw/tds_mamp';
notes{85} = 'SolO RPW TDS MAMP data (L2)';
multi(85) = 0;

prods{86} = 'solo_rpw_tds_stat';
paths{86} = 'solo/rpw/tds_stat';
notes{86} = 'SolO RPW TDS statitical data (L2)';
multi(86) = 0;

prods{87} = 'solo_epd_ept_hcad';
paths{87} = 'solo/epd/ept/hcad';
notes{87} = 'SolO EPD EPT High Cadence (L2)';
multi(87) = 0;

prods{88} = 'solo_epd_ept_erates';
paths{88} = 'solo/epd/ept/erates';
notes{88} = 'SolO EPD EPT Electron Flux in Rates Mode (L2)';
multi(88) = 0;

prods{89} = 'solo_epd_ept_irates';
paths{89} = 'solo/epd/ept/irates';
notes{89} = 'SolO EPD EPT Proton and Alpa Fluxes in Rates Mode (L2)';
multi(89) = 0;

prods{90} = 'solo_epd_step_rates';
paths{90} = 'solo/epd/step';
notes{90} = 'SolO EPD STEP Rates (L2)';
multi(90) = 0;

prods{91} = 'solo_swa_pas_eflux';
paths{91} = 'solo/swa/pas/eflux';
notes{91} = 'SolO SWA PAS Differential flux (L2)';
multi(91) = 0;

prods{92} = 'solo_swa_pas_mom';
paths{92} = 'solo/swa/pas/moments';
notes{92} = 'SolO SWA PAS moments (L2)';
multi(92) = 0;

prods{93} = 'solo_rpw_bia_density';
paths{93} = 'solo/rpw/lfr_density';
notes{93} = 'SolO RPW LFR electron density (L3)';
multi(93) = 0;

prods{94} = 'solo_rpw_bia_scpot';
paths{94} = 'solo/rpw/lfr_scpot';
notes{94} = 'SolO RPW LFR SC potential (L3)';
multi(94) = 0;

prods{95} = 'solo_rpw_tnr_density';
paths{95} = 'solo/rpw/tnr_density';
notes{95} = 'SolO RPW TNR electron density (L3)';
multi(95) = 0;

prods{96} = 'solo_rpw_bia_vht';
paths{96} = 'solo/rpw/lfr_vht';
notes{96} = 'SolO RPW LFR SW velocity estimates (L3)';
multi(96) = 0;

prods{97} = 'solo_swa_pas_vdf';
paths{97} = 'solo/swa/pas/vdf';
notes{97} = 'SolO SWA PAS Velocity Distribution Function (L2)';
multi(97) = 0;

if ~exist('product','var') || isempty(product)
	fprintf(1,'\n');
	for i=1:length(prods)
        msc = 'S';
        if (multi(i))
            msc = 'M';
        end
		fprintf(1,'%24s  %s %s\n', prods{i}, msc, notes{i});
	end
	return;
end

pstr  = [];
ppath = [];
pnum = 0;
multisc = 0;

if (isnumeric(product))
	if (product <= length(prods))
		pstr  = prods{product};
		ppath = paths{product};
		pnum = product;
		multisc = multi(pnum);
	end
else
	for i=1:length(prods)
		if (strcmp(prods{i}, product))
			pstr = product;
			pnum = i;
			ppath = paths{pnum};
			multisc = multi(pnum);
			return;
		end
	end
end
