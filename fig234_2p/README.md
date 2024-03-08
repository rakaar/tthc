# Figures
- BF, BF0 - `bf_plots_gender_wise`
- HE,HS, NE, NS - `he_hs_as_func_of_rebf_gender_wise`

# rms_match_db Column descriptions
1. Animal name
2. location
3. Cell number
4. Tone: Location of original file from whch data is taken(Have to change path. Name remains same)
5. (4) but for HC
6. Tone attenuation dB SPL
7. Hc attenuation dB SPL
8. Tone response - (7 freq x 1) cell - each cell is 5 iters x 30 frames
9. (8) but for HC
10. X co-ordinate of cell
11. Y -coordinate of cell



## New files
- indiv_he_hs_classifier.m - classify each case as he,hs
- get_all_rows_frm_struct.m - function to get all rows from struct
- each_neuron_enh_sup.m - for each neuron,see how many cases are HE, HS, NE, NS

## To get Sig and best freq of cells
1. Copy rms_match_db.mat from `2p_db`
2. Run `sig_bf_on_rms_match`.
3. Save the database variable - `rms_match_db` as `rms_match_db_with_sig_bf`
4. Run `CHECK_sig_val.m` to check bf and sig are correct

## To get figures
1. Run `bf_plots.m`