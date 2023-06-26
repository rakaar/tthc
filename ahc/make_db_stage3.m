clear; close all;
load('stage2_db.mat')

for u=1:size(stage2_db,1)
    if isempty(stage2_db{u,1})
        continue
    end
    tone_rates = stage2_db{u,6};
    tone_avg_res = zeros(13,1);
    tone_sig_vals = zeros(13,1);

    spont = [];
    % collect spont
    for f=1:13
        spont = [spont; mean(tone_rates{f,1}(:,431:500),2)];
    end % f

    for f=1:13
        f_rates = mean(tone_rates{f,1}(:, 501:570),2);
        h = ttest2(spont, f_rates);

        if mean(f_rates) < mean(spont)
            h = -h;
        end
        
        tone_sig_vals(f) = h;
        tone_avg_res(f) = mean(f_rates);
    end % ttest

    tone_sig1 = find(tone_sig_vals == 1);
    if ~isempty(tone_sig1)
        tone_avg_res1 = tone_avg_res(tone_sig1);
        [max_val, max_ind] = max(tone_avg_res1);
        bf_ind = tone_sig1(max_ind);
    else
        bf_ind = -1;
    end
    stage2_db{u,9} = bf_ind;
    

end % u

% HC 
% NOT changing var names, just changing index

for u=1:size(stage2_db,1)
    if isempty(stage2_db{u,1})
        continue
    end
    tone_rates = stage2_db{u,7};
    tone_avg_res = zeros(13,1);
    tone_sig_vals = zeros(13,1);

    spont = [];
    % collect spont
    for f=1:13
        spont = [spont; mean(tone_rates{f,1}(:,431:500),2)];
    end % f

    for f=1:13
        f_rates = mean(tone_rates{f,1}(:, 501:570),2);
        h = ttest2(spont, f_rates);

        if mean(f_rates) < mean(spont)
            h = -h;
        end
        
        tone_sig_vals(f) = h;
        tone_avg_res(f) = mean(f_rates);
    end % ttest

    tone_sig1 = find(tone_sig_vals == 1);
    if ~isempty(tone_sig1)
        tone_avg_res1 = tone_avg_res(tone_sig1);
        [max_val, max_ind] = max(tone_avg_res1);
        bf_ind = tone_sig1(max_ind);
    else
        bf_ind = -1;
    end
    stage2_db{u,10} = bf_ind;
    

end % u

stage3_db = stage2_db;
save('stage3_db', 'stage3_db')