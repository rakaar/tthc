%% near far
freqs = [6 8.5 12 17 24 34 48]; 
near_far_db = cell(500,2); % 1 - near:0/far:1, 2 - he:1/hs:2/ne:3/ns:4
for u=1:500
    bf_hc = ephys_rms_match_db{u,21};
    bf_t = ephys_rms_match_db{u,22};

    if isempty(bf_hc) || bf_hc == -1
        continue
    end

    if isempty(bf_t) || bf_t == -1
        continue
    end

    bf_t_index = find(freqs  == bf_t);
    bf_hc_index = find(freqs == bf_hc);
    hc2_index = bf_hc_index + 2;

    oct_apart1 = abs((bf_hc_index - bf_t_index)*0.5);
    oct_apart2 = abs((hc2_index - bf_t_index)*0.5);

    % near = 0, far = 1
    if oct_apart1 <= 1 && oct_apart2 <= 1
        near_or_far = 0;
    else
        near_or_far = 1;
    end

    
    % sig values 
    hc_sigs = ephys_rms_match_db{u,19};
    t_sigs = ephys_rms_match_db{u,20};

    t1t2_sig = hc_sigs(bf_hc_index);
    t1_sig = t_sigs(bf_hc_index);
    if bf_hc_index + 2 > 7
        continue
    end
    t2_sig = t_sigs(bf_hc_index + 2);

    if isnan(t1t2_sig) || isnan(t1_sig) || isnan(t2_sig)
        continue
    end
    % classification of cases
    if t1t2_sig + t1_sig + t2_sig == 0
        res_type = 4; % NS 
    elseif t1t2_sig == 1 && (t1_sig  + t2_sig == 0)
        res_type = 1; % HE
    elseif t1t2_sig == 0 && (t1_sig == 1 || t2_sig == 1)
        res_type = 2; % HS
    elseif t1t2_sig == 1 && (t1_sig + t2_sig == 1)
        % TODO - ttests and ne and not ne
        if t1_sig == 1
        elseif t2_sig == 1
        end

    elseif t1t2_sig + t1_sig + t2_sig == 3
     % todo - largest mean
     % ttest - ne and not ne
    end


    
   


end
%% 