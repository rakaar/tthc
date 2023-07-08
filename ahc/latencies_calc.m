% Calculate latencies of tone responses
clear;
load('stage3_db.mat')

all_latencies = [];

% responses to tone at 6
for u=1:size(stage3_db,1)
    tone_rates = stage3_db{u,6};
    for f=1:13
        f_rates = tone_rates{f,1};
        latencies_5 = zeros(5,1);
        for i=1:5
            rate_each_iter = f_rates(i,501:570);
            all_ones = find(rate_each_iter == 1);
            if isempty(all_ones)
                latencies_5(i,1) = nan;
            else
                latencies_5(i,1) = all_ones(1);
            end  % if
        end  % i

        all_latencies = [all_latencies; nanmean(latencies_5)]; 
    end % f    
end % u


figure
    histogram(all_latencies)
    xlabel('Latency (ms)')
    ylabel('Count')
    title('Mean latency of each Tone frequency for all AHC units')