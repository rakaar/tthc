clear
rms_match_db_with_sig_bf = load('/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/PV/rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;


cell_to_type_map = containers.Map;

for u = 1:size(rms_match_db_with_sig_bf,1)
    tone_rates = rms_match_db_with_sig_bf{u,8};
    hc_rates = rms_match_db_with_sig_bf{u,9};
    tone_sig_vec = rms_match_db_with_sig_bf{u,10};
    hc_sig_vec = rms_match_db_with_sig_bf{u,12};


    tone_rates_5 = zeros(5,1);
    hc_rates_5 = zeros(5,1);
    tone_sig_val = zeros(5,1);

end