% In rms_match_db_with_sig_bf, remove all non-20

rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
remove_indices = [];
for u = 1:size(rms_match_db_with_sig_bf,1)
    if rms_match_db_with_sig_bf{u,6} ~= 20
        remove_indices = [remove_indices; u];
    end
end
rms_match_db_with_sig_bf(remove_indices,:) = [];


save('rms_match_db_with_sig_bf.mat', 'rms_match_db_with_sig_bf')