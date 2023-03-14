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

%% diff in latencies
all_lates = [];
% latencies at bf
for u=1:643
    % T 
    bf_ind = 12;
    rate_ind = 6;
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
     end

    late1 = mean_latency;

    % HC
    bf_ind = 13;
    rate_ind = 7;
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
     end

    late2 = mean_latency;

    
    all_lates = [ all_lates (late2 - late1)];
   

end


figure
    hist(all_lates,28)

%%
all_lates = [];
% latencies at bf
for u=1:643
    % T 
    bf_ind = 12;
    rate_ind = 6;
    tbf = rms_match_db{u,bf_ind};
    if tbf == -1 
        continue
    end
    rates = rms_match_db{u,rate_ind}{tbf,1}(:, 501:570);
    mean_latency = 0;
    lates1 = [];
    isempty_r1pos = 0;
    for iter=1:5
        r = rates(iter,:);
        r1pos = find(r == 1);
        if ~isempty(r1pos)
            lates1 = [lates1 r1pos(1)];
        else
            lates1 = [lates1 nan];
        end
        
    end
    non_nan_lates = lates1(~isnan(lates1));
    if length(non_nan_lates) >= 3
        late1 = mean(non_nan_lates);
    else
       continue
    end

    % HC
    bf_ind = 13;
    rate_ind = 7;
    if tbf == -1 
        continue
    end
    rates = rms_match_db{u,rate_ind}{tbf,1}(:, 501:570);
    mean_latency = 0;
    lates1 = [];
    isempty_r1pos = 0;
    for iter=1:5
        r = rates(iter,:);
        r1pos = find(r == 1);
        if ~isempty(r1pos)
            lates1 = [lates1 r1pos(1)];
        else
            lates1 = [lates1 nan];
        end
        
    end
    non_nan_lates = lates1(~isnan(lates1));
    if length(non_nan_lates) >= 3
        late2 = mean(non_nan_lates);
    else
       continue
    end


    
    all_lates = [ all_lates (late2 - late1)];
   

end


figure
    hist(all_lates,36)

