# Figures
- BF, BF0 plots: `bfs_gender_wise`
- HE, HS, NE, NS plots: `he_hs_as_func_of_re_bf_gender_wise`

# rms_match_db - Database - Column descriptions
1. Animal name(Male name contain '_M', female '_F') `contains(animal_name, '_M') for male`
2. location of electrode
3. Channel Number. Type string
4. Tone stim attenuation(dB SPL)
5. HC stim attenuation(dB SPL)
6. TONE Stimuli: 7 x 1 cell.  7 - for 7 freq stimulus. Each cell is 5 x 2500. 5 iters and 2500 ms bins. 1/0 - spike or not
7. Same as above, but for HC stimuli
8. TONE stimuli: 7 x 1 vec. 1 - response signigicantly > spont. 0- Not
9. Same as above, but for HC stimuli
10. Tone stimulus: 7 x 1 vector. Mean response for a each stimulus. In spikes/ms
11. Same as above for HC stimulus
12. Best Frequency(BF). -1 indicates no BF, as sig response to No Tone stim
13. Best fundamental Frequency(BF0). -1 indicates no BF0, as sig responses to No HC


## New files
- fig1_ephys\see_raster_for_he_hs.m - example figure of raster for HE, HS
- bfs_20.m - in 20 dB only, bf figures
- each_neuron_enh_sup.m - for each neuron,see how many cases are HE, HS, NE, NS
- get_all_rows_frm_struct.m - function to get all rows from struct
- he_hs_as_func_of_re_bf.m - HE, HS as function of re BF
- he_hs_classifier - func classify if a unit is HE, HS, NE, NS
- indiv_he_hs_classifier.m - func to classifiy indiv case
- linear_index_re_bf.m - linear index of re BF
- norm_he_hs_re_bf.m - norm the rates by bf and bf0 response and calculate he,hs prop vs rebf, same as without normalising
-  fit_line_vs_rebf.m - linear fit of hc rate vs re bf
To get near far
1. Run near_far_he_hs.m
2. near_far_units - 2 x 4. 2-near,far. 4-he,hs,ne,ns
3. To check, run `test_he_hs_ne_ns.m`

To get noise corr plots
0. `noise_corr.m`
1. `noise_corr_db.m`
2. Run `noise_corr_plots` to get the figures

To get noise corr db
1. Run noise_corr.m
2. Save tone_noise_corr_db, hc_noise_corr_db
3. Run noise_corr_db
4. Then noise_corr_plots

## Noise corr
1. all_noise_corr_scripts_run.m - Run all noise corr scripts