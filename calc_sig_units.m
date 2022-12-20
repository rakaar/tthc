for u=1:unit_counter-1
    % get spont 
    spont_pts = [];
    for freq=5:18
        spikes = ephys_rms_match_db{u,freq};
        if isempty(spikes)
            continue
        end
        spont_pts = [spont_pts;  mean(spikes(:,431:500),2)];
    end

    % for hc res
    h = [];
    for freq = 5:11
        spikes = ephys_rms_match_db{u,freq};
        if isempty(spikes) || size(spikes,1) < 3
            h = [h NaN];
            continue
        end

        res = mean(spikes(:, 501:570), 2);
        critical_val = ttest2(res, spont_pts);
        if mean(res) < mean(spont_pts)
                critical_val = -critical_val;
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
        critical_val = ttest2(res, spont_pts);
        if mean(res) < mean(spont_pts)
                critical_val = -critical_val;
        end
        h = [h critical_val];
    end % end of freq=12:18
    ephys_rms_match_db{u,20} = h;
end

