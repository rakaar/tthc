# New db (24 Feb,2022)

To generate database
1. Go to `ephys_new_db`
2. Run `make_new_db_t_hc_seperate`, get `ephys_db`. (Change stim type to get tone seperate hc seperate)
3. Name it `tone_db_stage1.mat`, `hc_db_stage1.mat`
4. Run `make_new_db_stage2.m`
5. Name it `ephys_tone_33.mat`, `ephys_hc_33.mat`
6. Go to folder `ephys_sig_bf` 
7. Run `sig_matrix_bf.m`
8. Name it `ephys_tone_33_5_and_6_sig_7_rates_8_bf`, `ephys_hc_33_5_and_6_sig_7_rates_8_bf`
9. Run make_map_t_hc_locations.m 
10. Run `make_rms_match_db.m`
11. Name it `make_rms_match_db`

To check DB
1. Go to folder `check_every_db`
2. Copy all the database files create in the above check
3. Run all matlab files

To change from 'd_prime' to 'ttest'
1. Go to folder `ephys_sig_bf`
2. Go to file `sig_matrix_bf.m`
3. In these lines
```
d_prime = (mean_rates_f - mean_spont)/((std_rates_f^2  +  std_spont^2)^0.5);
            if d_prime > 1
                sig_matrix(f,d) = 1;
            else
                sig_matrix(f,d) = 0;
            end
```
Change them to ttest2
4. Go to guideline - `To generate database`, follow steps-8,9,10(to get new rms match db)
5. Go to guideline - `To check DB`
6. Change from `d_prime` to `ttest` in `check_db3`
7. Run all files in check db to confirm then new database




-----------------------------------
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


