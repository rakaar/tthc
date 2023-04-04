% due to shortage of data,
% new near&far criteria
% 3 - cols
% 1 - Tone - tone with freq within 1 oct of best freq
% 2 - AHC - ahc with base freq within 1 oct of best freq
% 3 - HC - HC with base freq within 1 oct of best freq

clear 
close all

load('stage3_db.mat')
load('stage1_db.mat')
load('f13.mat')

near_unit_rates = cell(13,3);
far_unit_rates = cell(13,3);

for u=1:size(stage3_db,1)
    tbf = stage3_db{u,9};
    if tbf == -1
        continue
    end
    
    tone_rates = stage3_db{u,6};
    hc_rates = stage3_db{u,7};
    
    % T 
    for f=1:13
        if abs(f - tbf) <= 2 % near
            near_unit_rates{tbf,1} = [near_unit_rates{tbf,1} mean(mean(tone_rates{f,1}(:,501:570),2))];
        else % far
            far_unit_rates{tbf,1} = [far_unit_rates{tbf,1} mean(mean(tone_rates{f,1}(:,501:570),2))];
        end
    end % f

    % HC 
    for f=1:13
        if abs(f - tbf) <= 2 % near
            near_unit_rates{tbf,3} = [near_unit_rates{tbf,3} mean(mean(hc_rates{f,1}(:,501:570),2))];
        else % far
            far_unit_rates{tbf,3} = [far_unit_rates{tbf,3} mean(mean(hc_rates{f,1}(:,501:570),2))];
        end
    end % f

    % AHC
    ahc_units = stage3_db{u,8};
    for ahc_u=ahc_units
        freqs_played = stage1_db{ahc_u,6}; % 2 x 6
        base_freqs = freqs_played(1,1:2);
        ahc_rates = stage1_db{ahc_u,7};
        %--- 1 3 5
        ahc_base_freq1_ind = my_find(f13, base_freqs(1));
        if abs(ahc_base_freq1_ind - tbf) <= 2 % near
            for f=[3,5]
                near_unit_rates{tbf,2} = [near_unit_rates{tbf,2} mean(mean(ahc_rates{f,1}(:,501:570),2))];
            end
        else %  far
            for f=[3,5]
                far_unit_rates{tbf,2} = [far_unit_rates{tbf,2} mean(mean(ahc_rates{f,1}(:,501:570),2))];
            end
        end
        %--- 2 4 6
        ahc_base_freq2_ind = my_find(f13, base_freqs(2));
        if abs(ahc_base_freq2_ind - tbf) <= 2 % near
            for f=[4,6]
                near_unit_rates{tbf,2} = [near_unit_rates{tbf,2} mean(mean(ahc_rates{f,1}(:,501:570),2))];
            end
        else %  far
            for f=[4,6]
                far_unit_rates{tbf,2} = [far_unit_rates{tbf,2} mean(mean(ahc_rates{f,1}(:,501:570),2))];
            end
        end
    end % ahc u
end % u


%%
near_unit_rates_avg = zeros(13,3);
far_unit_rates_avg = zeros(13,3);

for f=1:13
    for c=1:3
        near_unit_rates_avg(f,c) = mean(near_unit_rates{f,c});
        far_unit_rates_avg(f,c) = mean(far_unit_rates{f,c});
    end
end

figure
    alpha = double(~isnan(near_unit_rates_avg));
    imagesc(near_unit_rates_avg, 'AlphaData', alpha);
    xticks(1:3)
    xticklabels({'T', 'AHC', 'HC'})
    clim([0 max(max(near_unit_rates_avg))])
    colorbar
    title('Near')

figure
    alpha = double(~isnan(far_unit_rates_avg));
    imagesc(far_unit_rates_avg, 'AlphaData', alpha);
    xticks(1:3)
    xticklabels({'T', 'AHC', 'HC'})
    clim([0 max(max(near_unit_rates_avg))])
    colorbar
    
    title('Far')
    %% ttest
    ttest_results = nan(13,3); % t,ah ah,h, t,h;
    for f=1:13
        if isempty(near_unit_rates{f,1}) || isempty(near_unit_rates{f,2}) || isempty(near_unit_rates{f,3})
            continue
        end
        ttest_results(f,1) = ttest2(near_unit_rates{f,1}, near_unit_rates{f,2});
        ttest_results(f,2) = ttest2(near_unit_rates{f,2}, near_unit_rates{f,3});
        ttest_results(f,3) = ttest2(near_unit_rates{f,3}, near_unit_rates{f,1});
    end
    disp('d')