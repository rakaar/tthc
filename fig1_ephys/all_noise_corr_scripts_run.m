% Run all Noise corr scripts
clear;
disp('--- ALL: Stage 1/3 ---')
noise_corr_stage1;

clear;
disp('--- ALL: Stage 2/3 ---')
noise_corr_stage2;

clear;
disp('--- ALL: Stage 3/3 - plots ---')
noise_corr_stage3_plots;



% disp('----- Only 20 dB -----')
% disp('--- 20 dB: Stage 1/2 ---')
% noise_corr_stage2_only_20;

% disp('--- 20 dB: Stage 2/2 - plots ---')
% noise_corr_stage3_plots;