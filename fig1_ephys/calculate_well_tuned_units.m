% calculate well tuned units number
% well tuned units are those which 

clear;
load('rms_match_db_with_sig_bf_and_noise.mat')
n_rows = size(rms_match_db_with_sig_bf_and_noise,1);
well_tuned_at_edge = zeros(n_rows,1);
well_tuned_at_mid = zeros(n_rows,1);

for u=1:n_rows
    tone_sig = rms_match_db_with_sig_bf_and_noise{u,10};

    % replace -1 with 0
    tone_sig(tone_sig==-1) = 0;

    % check at edges
    start_edges_sum = tone_sig(1) + tone_sig(2);
    end_edges_sum = tone_sig(end-1) + tone_sig(end);

    if start_edges_sum == 2 || end_edges_sum == 2
        well_tuned_at_edge(u) = 1;
    end


    % check in middle
    mid_sum = tone_sig(3) + tone_sig(4) + tone_sig(5);
    if mid_sum == 3
        well_tuned_at_mid(u) = 1;
    end

end % u


% results
disp(['well tuned at edge: ' num2str(sum(well_tuned_at_edge)) ' out of ' num2str(n_rows)])
disp(['well tuned at mid: ' num2str(sum(well_tuned_at_mid)) ' out of ' num2str(n_rows)])
disp(['Both at edge and middle: ' num2str(sum(well_tuned_at_edge & well_tuned_at_mid)) ' out of ' num2str(n_rows)])
disp(['Either at edge or middle: ' num2str(sum(well_tuned_at_edge | well_tuned_at_mid)) ' out of ' num2str(n_rows)])