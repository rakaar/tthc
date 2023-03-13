load("rms_match_db.mat")
stim = 'hc';
if strcmp(stim,'t')
    bf_ind = 12;
    rate_ind = 6;
else
    bf_ind = 13;
    rate_ind = 7;
end

all_lates = [];
% latencies at bf
for u=1:643
    tbf = rms_match_db{u,bf_ind};
    if tbf == -1 
        continue
    end
    rates = rms_match_db{u,rate_ind}{tbf,1}(:, 501:570);
    mean_latency = 0;
    isempty_r1pos = 0;
    for iter=1:5
        r = rates(iter,:);
        r1pos = find(r == 1);
        if isempty(r1pos)
            isempty_r1pos = 1;
            break
        end
        mean_latency = mean_latency + r1pos(1);
    end
    if isempty_r1pos == 1
        continue
    else
        mean_latency = mean_latency/5;
        all_lates = [all_lates mean_latency];
    end
end


figure
    hist(all_lates)
%% all , not only at bf
stim = 'hc';
if strcmp(stim,'t')
    bf_ind = 12;
    rate_ind = 6;
else
    bf_ind = 13;
    rate_ind = 7;
end

all_lates = [];
% latencies at bf
for u=1:643
 
    for tbf=1:7
            rates = rms_match_db{u,rate_ind}{tbf,1}(:, 501:570);
            mean_latency = 0;
            isempty_r1pos = 0;
            for iter=1:5
                r = rates(iter,:);
                r1pos = find(r == 1);
                if isempty(r1pos)
                    isempty_r1pos = 1;
                    break
                end
                mean_latency = mean_latency + r1pos(1);
            end

            if isempty_r1pos == 1
                continue
            else
                mean_latency = mean_latency/5;
                all_lates = [all_lates mean_latency];
            end
    end
end


figure
    hist(all_lates)

