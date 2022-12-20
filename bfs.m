fs = [6 8.5 12 17 24 34 48];
% 21 - hc bf0 
% 22 - tone bf
for u=1:445
    % for hc best
    res = [];
    h = ephys_rms_match_db{u,19};
    for freq=5:11
        spikes = ephys_rms_match_db{u,freq};
        
        if isempty(spikes) || h(freq-4) ~= 1 || isnan(h(freq-4))
            res = [res -1];
        else
            res = [res mean( mean(spikes(:,501:570),2)  )];
        end
    end

    if sum(res) == -7 % if no significant res to all freqs
        ephys_rms_match_db{u,21} = -1;
    else
        [max_res idx] = max(res);
        bf = fs(idx);
        ephys_rms_match_db{u,21} = bf;
    end

    



    % for tone best
    res = [];
    h = ephys_rms_match_db{u,20};
    for freq=12:18
        spikes = ephys_rms_match_db{u,freq};
        
        if isempty(spikes) || h(freq-11) ~= 1 || isnan(h(freq-11))
            res = [res -1];
        else
            res = [res mean( mean(spikes(:,501:570),2)  )];
        end
    end

    if sum(res) == -7 % if no significant res to all freqs
        ephys_rms_match_db{u,22} = -1;
    else 
        [max_res idx] = max(res);
        bf = fs(idx);
        ephys_rms_match_db{u,22} = bf;
    end

   
end