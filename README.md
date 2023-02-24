# New db (24 Feb,2022)

To generate database
1. Go to `ephys_new_db`
2. Run `make_new_db_t_hc_seperate`, get `ephys_db`. (Change stim type to get tone seperate hc seperate)
3. Name it `tone_db_stage1.mat`, `tone_db_stage1.mat`
4. Run `make_new_db_stage2.m`
5. Name it `ephys_tone_33.mat`, `ephys_hc_33.mat`
6. Go to `ephys_sig_bf`
7. Run `sig_matrix_bf.m`
8. Name it `ephys_tone_33_5_and_6_sig_7_rates_8_bf`, `ephys_hc_33_5_and_6_sig_7_rates_8_bf`
9. Run `make_rms_match_db.m`
10. Name it `make_rms_match_db`

To check DB
1. Go to folder `check_every_db`
2. Copy all the database files create in the above check
3. Run all matlab files



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


