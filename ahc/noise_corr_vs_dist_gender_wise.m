clear;close all;clc;
stage1_db = load('stage1_db.mat').stage1_db;

%%%%% MEDIAL %%%%
loc_mat=[[12 16 4 8];[11 15 3 7];[10 14 2 6];[9 13 1 5]];%%%%% CAUDAL %%%%   %%% TO CONVERT FROM ELECTRODE NUMBER TO LOATION
%%%%% LATERAL %%%

%%
dist = [];
for r=0:3
    for c=0:3
            dist = [dist r^2 + c^2];
    end
end

dist = unique(nonzeros(dist));

animal_gender = 'all';
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end

if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(stage1_db,1)
        animal_name = stage1_db{u,1};
        if contains(animal_name, strcat('_', rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end

    stage1_db(removal_indices,:) = [];
end


loc_map = containers.Map;
combiner = '***';

for u = 1:size(stage1_db,1)
    animal_name = stage1_db{u,1};
    loc = stage1_db{u,2};
    db_str = num2str(stage1_db{u,5});

    stim = stage1_db{u,4};
    stim_index = stim + 1;

    combined_name = strcat(animal_name, combiner, loc, combiner, db_str);

    if isKey(loc_map, combined_name)
        stim_units_cell = loc_map(combined_name);
        stim_units_cell{stim_index,1} = [stim_units_cell{stim_index,1} u];
        loc_map(combined_name) = stim_units_cell;
    else
        stim_units_cell =  cell(3,1);
        stim_units_cell{stim_index,1} = [stim_units_cell{stim_index,1} u];
        loc_map(combined_name) = stim_units_cell;
    end
end

all_keys = keys(loc_map);
tone_noise_corr = cell(length(dist),1);
ahc_low_noise_corr = cell(length(dist),1);
ahc_high_noise_corr = cell(length(dist),1);
hc_noise_corr = cell(length(dist),1);

for k = 1:length(all_keys)
    loc_name = all_keys{k};
    stim_units_cell = loc_map(loc_name);
    
    % tone 
    units_s = stim_units_cell{1,1};
    for i = 1:length(units_s)-1
        for j = i + 1:length(units_s)
            unit_i = units_s(i);
            unit_j = units_s(j);
            rates_i = stage1_db{unit_i,7};
            rates_j = stage1_db{unit_j,7};

            noise_vec_i = get_noise_vec(rates_i);
            noise_vec_j = get_noise_vec(rates_j);

            corrmat = corrcoef([noise_vec_i noise_vec_j]);
            corrval = corrmat(1,2);

            ch1 = stage1_db{unit_i,3};
            ch2 = stage1_db{unit_j,3};
            if ch1 == ch2
                continue
            end

            [r1,c1] = ind2sub([4 4], find(loc_mat == ch1));
            [r2,c2] = ind2sub([4 4], find( loc_mat == ch2));

            d = (r1-r2)^2 + (c1-c2)^2;
            dpos = find(dist == d);

            tone_noise_corr{dpos,1} = [tone_noise_corr{dpos,1} corrval];
        end
    end % tone

    % harmonic
    units_s = stim_units_cell{2,1};
    for i = 1:length(units_s)-1
        for j = i + 1:length(units_s)
            unit_i = units_s(i);
            unit_j = units_s(j);
            rates_i = stage1_db{unit_i,7};
            rates_j = stage1_db{unit_j,7};

            noise_vec_i = get_noise_vec(rates_i);
            noise_vec_j = get_noise_vec(rates_j);

            corrmat = corrcoef([noise_vec_i noise_vec_j]);
            corrval = corrmat(1,2);

            ch1 = stage1_db{unit_i,3};
            ch2 = stage1_db{unit_j,3};
            if ch1 == ch2
                continue
            end

            [r1,c1] = ind2sub([4 4], find(loc_mat == ch1));
            [r2,c2] = ind2sub([4 4], find( loc_mat == ch2));

            d = (r1-r2)^2 + (c1-c2)^2;
            dpos = find(dist == d);

            hc_noise_corr{dpos,1} = [hc_noise_corr{dpos,1} corrval];
        end
    end % harmonic 

 
    % non hc - low
    units_s = stim_units_cell{3,1};
    for i = 1:length(units_s)-1
        for j = i + 1:length(units_s)
            unit_i = units_s(i);
            unit_j = units_s(j);
            rates_i = stage1_db{unit_i,7};
            rates_j = stage1_db{unit_j,7};

            rates_i_combined = cell(2,1);
            rates_i_combined{1,1} = rates_i{3,1};
            rates_i_combined{2,1} = rates_i{4,1};

            rates_j_combined = cell(2,1);
            rates_j_combined{1,1} = rates_j{3,1};
            rates_j_combined{2,1} = rates_j{4,1};

            noise_vec_i = get_noise_vec(rates_i_combined);
            noise_vec_j = get_noise_vec(rates_j_combined);

            corrmat = corrcoef([noise_vec_i noise_vec_j]);
            corrval = corrmat(1,2);

            ch1 = stage1_db{unit_i,3};
            ch2 = stage1_db{unit_j,3};

            if ch1 == ch2
                continue
            end
            
            [r1,c1] = ind2sub([4 4], find(loc_mat == ch1));
            [r2,c2] = ind2sub([4 4], find( loc_mat == ch2));

            d = (r1-r2)^2 + (c1-c2)^2;
            dpos = find(dist == d);

            ahc_low_noise_corr{dpos,1} = [ahc_low_noise_corr{dpos,1} corrval];
        end
    end % non hc - low

     % non hc - high
     units_s = stim_units_cell{3,1};
        for i = 1:length(units_s)-1
            for j = i + 1:length(units_s)
                unit_i = units_s(i);
                unit_j = units_s(j);
                rates_i = stage1_db{unit_i,7};
                rates_j = stage1_db{unit_j,7};
    
                rates_i_combined = cell(2,1);
                rates_i_combined{1,1} = rates_i{5,1};
                rates_i_combined{2,1} = rates_i{6,1};
    
                rates_j_combined = cell(2,1);
                rates_j_combined{1,1} = rates_j{5,1};
                rates_j_combined{2,1} = rates_j{6,1};
    
                noise_vec_i = get_noise_vec(rates_i_combined);
                noise_vec_j = get_noise_vec(rates_j_combined);
    
                corrmat = corrcoef([noise_vec_i noise_vec_j]);
                corrval = corrmat(1,2);
    
                ch1 = stage1_db{unit_i,3};
                ch2 = stage1_db{unit_j,3};

                if ch1 == ch2
                    continue
                end
    
                [r1,c1] = ind2sub([4 4], find(loc_mat == ch1));
                [r2,c2] = ind2sub([4 4], find( loc_mat == ch2));
    
                d = (r1-r2)^2 + (c1-c2)^2;
                dpos = find(dist == d);
    
                ahc_high_noise_corr{dpos,1} = [ahc_high_noise_corr{dpos,1} corrval];
            end
        end % non hc - high
end



% return
% plot mean Tone noise corr with error bars in 9 bins
% mean of tone noise corr in 9 bins using cell fun
tone_noise_corr = cellfun(@(x) x(~isnan(x)), tone_noise_corr, 'UniformOutput', false);

mean_nc = cellfun(@mean, tone_noise_corr);
% err - std/sqrt(len)
err_nc = cellfun(@(x) std(x)/sqrt(length(x)), tone_noise_corr);
figure;
    plot(mean_nc, 'LineWidth', 2);
    hold on;
    errorbar(mean_nc, err_nc, 'LineWidth', 2);
    hold off;
    title(['Tone Noise Correlation' ' ' animal_gender]);
    xlabel('Distance');
    ylabel('Correlation');
    % saveas(gcf, ['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figNonHC/' animal_gender  '_tone_high_noise_corr.fig']);

% same plot for hc noise corr
hc_noise_corr = cellfun(@(x) x(~isnan(x)), hc_noise_corr, 'UniformOutput', false);
mean_nc = cellfun(@mean, hc_noise_corr);
% err - std/sqrt(len)
err_nc = cellfun(@(x) std(x)/sqrt(length(x)), hc_noise_corr);
figure;
    plot(mean_nc, 'LineWidth', 2);
    hold on;
    errorbar(mean_nc, err_nc, 'LineWidth', 2);
    hold off;
    title(['Harmonic Noise Correlation ' animal_gender ]);
    xlabel('Distance');
    ylabel('Correlation');
    % saveas(gcf, ['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figNonHC/' animal_gender  '_hc_noise_corr.fig']);

% same for low ahc
% filter nan in each cell block before taking mean
ahc_low_noise_corr = cellfun(@(x) x(~isnan(x)), ahc_low_noise_corr, 'UniformOutput', false);
mean_nc = cellfun(@mean, ahc_low_noise_corr);
% err - std/sqrt(len)
err_nc = cellfun(@(x) std(x)/sqrt(length(x)), ahc_low_noise_corr);
figure;
    plot(mean_nc, 'LineWidth', 2);
    hold on;
    errorbar(mean_nc, err_nc, 'LineWidth', 2);
    hold off;
    title(['Low AHC Noise Correlation ' animal_gender ]);
    xlabel('Distance');
    ylabel('Correlation');
    % saveas(gcf, ['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figNonHC/' animal_gender  '_ahc_low_noise_corr.fig']);
% same for high ahc
ahc_high_noise_corr = cellfun(@(x) x(~isnan(x)), ahc_high_noise_corr, 'UniformOutput', false);
mean_nc = cellfun(@mean, ahc_high_noise_corr);
% err - std/sqrt(len)
err_nc = cellfun(@(x) std(x)/sqrt(length(x)), ahc_high_noise_corr);
figure;
    plot(mean_nc, 'LineWidth', 2);
    hold on;
    errorbar(mean_nc, err_nc, 'LineWidth', 2);
    hold off;
    title(['High AHC Noise Correlation ' animal_gender]);
    xlabel('Distance');
    ylabel('Correlation');
    % saveas(gcf, ['/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC figs eps/figNonHC/' animal_gender  '_ahc_high_noise_corr.fig']);





    figure;
    hold on
    % Tone
        mean_nc = cellfun(@mean, tone_noise_corr);
        err_nc = cellfun(@(x) std(x)/sqrt(length(x)), tone_noise_corr);
        errorbar(mean_nc, err_nc, 'LineWidth', 2);
    % HC
        mean_nc = cellfun(@mean, hc_noise_corr);
        err_nc = cellfun(@(x) std(x)/sqrt(length(x)), hc_noise_corr);
        errorbar(mean_nc, err_nc, 'LineWidth', 2);

    % AHC low
        mean_nc = cellfun(@mean, ahc_low_noise_corr);
        err_nc = cellfun(@(x) std(x)/sqrt(length(x)), ahc_low_noise_corr);
        errorbar(mean_nc, err_nc, 'LineWidth', 2);
    
    % AHC high
        mean_nc = cellfun(@mean, ahc_high_noise_corr);
        err_nc = cellfun(@(x) std(x)/sqrt(length(x)), ahc_high_noise_corr);
        errorbar(mean_nc, err_nc, 'LineWidth', 2);
    hold off

    legend('T', 'HC', 'NHC-LOW', 'NHC-HIGH');
    title(['Noise corr vs dist -  Gender: ' animal_gender])
    xlabel('Distance');
    ylabel('Correlation');
 % stats test
  for i = 1:9
    disp(['== Dist num ' num2str(i) '=='])
    hc_corr = hc_noise_corr{i,1};
    ahc_low_corr = ahc_low_noise_corr{i,1};
    ahc_high_corr = ahc_high_noise_corr{i,1};

    disp('--HC vs AHC low--');
    [h,p] = ttest2(hc_corr, ahc_low_corr);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);
    [p,h] = ranksum(hc_corr, ahc_low_corr);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);

    disp('--HC vs AHC high--');
    [h,p] = ttest2(hc_corr, ahc_high_corr);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);
    [p,h] = ranksum(hc_corr, ahc_high_corr);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);

 end
    
 hc_corr_4bins = [];
 ahc_low_corr_4bins = [];
 ahc_high_corr_4bins = [];

 for i = 1:4
    hc_corr_4bins = [hc_corr_4bins hc_noise_corr{i,1}];
    ahc_low_corr_4bins = [ahc_low_corr_4bins ahc_low_noise_corr{i,1}];
    ahc_high_corr_4bins = [ahc_high_corr_4bins ahc_high_noise_corr{i,1}];
 end

 disp('4 bins - HC vs AHC low');
    [h,p] = ttest2(hc_corr_4bins, ahc_low_corr_4bins);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);
    [p,h] = ranksum(hc_corr_4bins, ahc_low_corr_4bins);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);
 disp('4 bins - HC vs AHC high');
    [h,p] = ttest2(hc_corr_4bins, ahc_high_corr_4bins);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);
    [p,h] = ranksum(hc_corr_4bins, ahc_high_corr_4bins);
    disp(['h = ' num2str(h) ' p = ' num2str(p)]);
 
 
 
 
 
 
 
 
 
 
 function noise_from_rates = get_noise_vec(rates_cell)
    noise_from_rates = [];
     for c = 1:size(rates_cell,1)
         rates_per_stim = rates_cell{c,1};
         rates_per_stim1 = mean(rates_per_stim(:, 501:570),2);
         rates_minus_mean = rates_per_stim1 - mean(rates_per_stim1);
         noise_from_rates = [noise_from_rates; rates_minus_mean];
 
     end
 end
 
