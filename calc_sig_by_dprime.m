% instead of ttest - use the condition  d_prime > 1 and z-score >= 2
for u=1:unit_counter-1
    % get spont 
    spont_pts = [];
    for freq=5:18
        spikes = ephys_rms_match_db{u,freq};
        if isempty(spikes)
            continue
        end
        spont_pts = [spont_pts;  mean(spikes(:,301:500),2)];
    end

    mean_spont = mean(spont_pts);
    sd_spont = std(spont_pts);

    % for hc res
    h = [];
    for freq = 5:11
        spikes = ephys_rms_match_db{u,freq};
        if isempty(spikes) || size(spikes,1) < 3
            h = [h NaN];
            continue
        end

        res = mean(spikes(:, 501:570), 2);
        mean_res = mean(res);
        sd_res = std(res);

       
        d_prime = (mean_res - mean_spont)/(sd_res^2 + sd_spont^2)^0.5;
        

        if d_prime > 1
            critical_val = 1; 
        else 
             critical_val = 0;
        end

        h = [h critical_val];
    end % end of freq=5:11
    ephys_rms_match_db{u,19} = h;
    


    % for tone res
    h = [];
    for freq = 12:18
        spikes = ephys_rms_match_db{u,freq};
        if isempty(spikes) || size(spikes,1) < 3
            h = [h NaN];
            continue
        end

        res = mean(spikes(:, 501:570), 2);
        mean_res = mean(res);
        sd_res = std(res);

       
        d_prime = (mean_res - mean_spont)/(sd_res^2 + sd_spont^2)^0.5;
        

        if d_prime > 1
            critical_val = 1; 
        else 
             critical_val = 0;
        end

        h = [h critical_val];
    end % end of freq=12:18
    ephys_rms_match_db{u,20} = h;
end

