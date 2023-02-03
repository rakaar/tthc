ephys_rms_match_db
ephys_data.mat

cols: 1,2- HC file,tone file,
3,4 - HC(d),tone(d-5) intensity,
5-11 : HC res,
12-18: Tone res, 
19,20-sig in HC,sig in tone
21,22 - bf hc, bf t
29 - animal-location,
30- channel number
23 - spont

bf_map: for each animal-location-channel - at lowest intensity : bf_t, bf_h


files:-
1. make_ep_db - make this db - ephys_rms_match_db
2. calc_sig_units - adds significance test for each freq in db using ttest2/ calc_sig_by_dprime.m - calculate same sig using d prime
3. bfs.m - calculate bf based on significance
4. bf_location-wise_lowest_db - bf at lowest db
5. bf_plots - analysis of bf and bf0


