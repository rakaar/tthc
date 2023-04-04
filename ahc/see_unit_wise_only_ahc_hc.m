% compare H and AHC 
clear 
close all

load('f13.mat')
load('stage1_db.mat')

ahc_hc_rates = cell(13,3);

for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        freqs = stage1_db{u,6};
        rates = stage1_db{u,7};
        
        % base freq1 1 3 5
        basef1 = freqs(1,1);
        basef1_index = my_find(f13, basef1);
        ahc_hc_rates{basef1_index,1} = [ahc_hc_rates{basef1_index,1} mean(mean(rates{1,1}(:,501:570),2))];
        ahc_hc_rates{basef1_index,2} = [ahc_hc_rates{basef1_index,2} mean(mean(rates{3,1}(:,501:570),2))];
        ahc_hc_rates{basef1_index,3} = [ahc_hc_rates{basef1_index,3} mean(mean(rates{5,1}(:,501:570),2))];

            
        % basef2 2 4 6
        basef1 = freqs(1,2);
        basef1_index = my_find(f13, basef1);
        ahc_hc_rates{basef1_index,1} = [ahc_hc_rates{basef1_index,1} mean(mean(rates{2,1}(:,501:570),2))];
        ahc_hc_rates{basef1_index,2} = [ahc_hc_rates{basef1_index,2} mean(mean(rates{4,1}(:,501:570),2))];
        ahc_hc_rates{basef1_index,3} = [ahc_hc_rates{basef1_index,3} mean(mean(rates{6,1}(:,501:570),2))];
    end % if
end % u

%% avg of the above
ahc_hc_rates_avg = zeros(10,3);
% as only 10 are there
for f=1:10
    for c=1:3
        ahc_hc_rates_avg(f,c) = mean(ahc_hc_rates{f,c});
    end
end 

figure
    imagesc(ahc_hc_rates_avg)
    title('hc with ahc')
     xticks(1:3)
    xticklabels({'HC', 'AHC low', 'AHC high'})
    colorbar
figure
    plot(ahc_hc_rates_avg')

    %% tteests
    ttest_hc_ahc = zeros(10,3);
    % 1-hc with ahc low, 2 - hc with ahc high, 3 - btn ahc low and high

    for f=1:10
        ttest_hc_ahc(f,1) = ttest(ahc_hc_rates{f,1},ahc_hc_rates{f,2});
        ttest_hc_ahc(f,2) = ttest(ahc_hc_rates{f,1},ahc_hc_rates{f,3});
        ttest_hc_ahc(f,3) = ttest(ahc_hc_rates{f,2},ahc_hc_rates{f,3});
    end

    %% see within each freqs
%     for f=1:10
%         hrates = ahc_hc_rates{f,1};
%         ahrates1 = ahc_hc_rates{f,2};
%         ahrates2 = ahc_hc_rates{f,3};
% 
%         combined = [hrates; ahrates1; ahrates2];
%         plot(combined)
%         title(num2str(f))
%         pause
%     end