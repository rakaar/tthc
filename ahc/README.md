## Database making
1. make_db_stage1.m 
2. make_db_stage2.m
3. make_db_stage3.m

## Results
1. ttests_btn_low_ahc_hc_and_high_hc.m - sig diff btn HC and AHC high(Non normalised)
2. norm_ttests_btn_low_ahc_hc_and_high_hc.m - same as above, rates norm by hc rates
3. seperate_low_high_into_further.m - ahc into 2 diff low, 2 diff high
4. norm_seperate_low_high_into_further.m - same as above, rates norm by hc rates
5. correlation_btn_hc_ahc_high_low.m - correlation btn hc,ahc low and high
6. see_off_at_bf_and_beside_bf.m - off - HC vs AHC low vs AHC high
7. see_off_at_bf_and_beside_along_with_tones.m - off - HC vs AHC L vs AHC H vs Tones
8. see_off_at_bf_and_beside_bf_moving_mean.m - Off btn HC, AHC-L, AHC-H moving avg fashion
9. see_off_at_bf_and_beside_along_with_tones.m - including Tones also, comparison moving avg

10. see_off_at_bf_and_beside_along_with_tones.m - Generate bar graphs of off response between 800 and 900 ms, with significant tests as disp
11. Fig_see_resp_of_all_4_h_ahl_ahh_t.m - same as above, but at stim res 500 +  1 - 70 ms
12. Fig_ttests_btn_ahc_hc_t.m - Generate box plot of stim response of H, AHC, T with ttest and ranksum between them
13. Fig_ttests_btn_ahc_hc_t_at_bf_near_far.m  - same as above, BUT ONLY BASE FREQUENCIES IN ALL,BF,NEAR,FAR
14. Fig_ttests_btn_ahc_hc_t_at_bf_near_far_normalised.m - same as above, but normalised by best freq
15. Fig_near_far_enh_sup.m - In case of aharmonic, Near Far
16. Fig_near_far_enh_sup_with_harmonic.m - Same as above, but with harmonic
17. test_btn_near_far_in_hc_ahc.m - Chi square test, Fisher exact test for hc vs ahc in near far for num of cases - enh,sup,ne,ns
18. exp_pca.m - PCA of HC, AHC Low, AHC High rates
19. number_of_sig_units.m - Number of units  responding to only HC, only AHC and both
20. hc_ahc_rates_vs_bf.m - % HC, AHC rates vs ...BF-0.25, BF, BF+0.25 ...
21. sig_btn_hc_and_others.m - For the graph generated from above, do unpaired tests btn HC and Non-HC
22. average_tuning.m - Normalised rates vs BF-0.25, BF, BF + 0.25. Same for BF0 as well. Just a variable to be swtiched
23. hc_ahc_linear_checks.m - Linear index for all stim vs Octaves apart from BF or BF0
24. sig_diff_in_hc_ahc_linear_check.m - Sig difference in the graph obtained above
25. linearity_check_from_tuning_curive - compare AHC/HC in ideal linear case from BFtuning and two tone responses ratio normalised by BF
26. linear_check_in_each_unit.m - Calculate (non harmonic rate/ individual tone rates sum) // (harmonic rate/ individual tone rates sum)
27. make_all3_stages_db.m - Make db for all 3 stages