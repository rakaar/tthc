## New files
bfs_20.m - in 20 dB only, bf figures
each_neuron_enh_sup.m - for each neuron,see how many cases are HE, HS, NE, NS
get_all_rows_frm_struct.m - function to get all rows from struct
he_hs_as_func_of_re_bf.m - HE, HS as function of re BF
he_hs_classifier - func classify if a unit is HE, HS, NE, NS
indiv_he_hs_classifier.m - func to classifiy indiv case

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