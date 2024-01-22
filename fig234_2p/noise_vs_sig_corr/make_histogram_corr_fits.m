rms_match_db_with_sig_bf = load('/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/SOM/rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;

% GENDER
animal_gender = 'F'; % M for Male, F for Female, all for both
if strcmp(animal_gender, 'M')
    rejected_gender = 'F';
elseif strcmp(animal_gender, 'F')
    rejected_gender = 'M';
else
    rejected_gender = nan;
end

if ~isnan(rejected_gender)
    removal_indices = [];
    for u = 1:size(rms_match_db_with_sig_bf,1)
        animal_name = rms_match_db_with_sig_bf{u,1};
        % if animal name includes _{rejected_gender} add it to removal index
        if contains(animal_name, strcat('_',rejected_gender))
            removal_indices = [removal_indices; u];
        end
    end % u

    % remove rejected gender
    rms_match_db_with_sig_bf(removal_indices,:) = [];

end % if

disp(['Gender is ' animal_gender])

locations_map = containers.Map;
combiner = '***';
for u = 1:size(rms_match_db_with_sig_bf,1)
    animal = rms_match_db_with_sig_bf{u,1};
    loc = rms_match_db_with_sig_bf{u,2};
    spl = num2str(rms_match_db_with_sig_bf{u,6});

    keyname = [animal,combiner,loc,combiner,spl];
    
    if ~isKey(locations_map,keyname)
        locations_map(keyname) = [u];
    else
        units_arr = locations_map(keyname);
        units_arr = [units_arr;u];
       locations_map(keyname) = units_arr;
    end

        
end

location_map_keys = keys(locations_map);
counter = 1;

all_corr_vals = {
    'keyname', 'unit1', 'unit2', 'tone_sig_corr', 'tone_noise_corr', 'hc_sig_corr', 'hc_noise_corr';
    
};

for k = 1:length(location_map_keys)
    units_arr = locations_map(location_map_keys{k});
    if length(units_arr) > 1
        for u1 = 1:length(units_arr)-1
            for u2 = u1+1:length(units_arr)
                unit1 = units_arr(u1);
                unit2 = units_arr(u2);
                
                tone_rates_1 = rms_match_db_with_sig_bf{unit1,8};
                tone_rates_2 = rms_match_db_with_sig_bf{unit2,8};

                hc_rates_1 = rms_match_db_with_sig_bf{unit1,9};
                hc_rates_2 = rms_match_db_with_sig_bf{unit2,9};

                tone_tuing_curve1 = find_tuning_curve(tone_rates_1);
                tone_tuing_curve2 = find_tuning_curve(tone_rates_2);
                hc_tuning_curve1 = find_tuning_curve(hc_rates_1);
                hc_tuning_curve2 = find_tuning_curve(hc_rates_2);

                tone_noise_vec1 = find_noise_vec(tone_rates_1);
                tone_noise_vec2 = find_noise_vec(tone_rates_2);
                hc_noise_vec1 = find_noise_vec(hc_rates_1);
                hc_noise_vec2 = find_noise_vec(hc_rates_2);

                tone_sig_corr = corr(tone_tuing_curve1,tone_tuing_curve2);
                tone_noise_corr = corr(tone_noise_vec1,tone_noise_vec2);
                hc_sig_corr = corr(hc_tuning_curve1,hc_tuning_curve2);
                hc_noise_corr = corr(hc_noise_vec1,hc_noise_vec2);

                all_corr_vals = [all_corr_vals; {location_map_keys{k},  unit1, unit2, tone_sig_corr, tone_noise_corr, hc_sig_corr, hc_noise_corr}];

            end
        end
    end
end

save('all_corr_vals', 'all_corr_vals')

clear;

db = load('all_corr_vals.mat').all_corr_vals;

% all_corr_vals = {
%     'keyname', 'unit1', 'unit2', 'tone_sig_corr', 'tone_noise_corr', 'hc_sig_corr', 'hc_noise_corr';
    
% };

% histograms
tone_sig_corr_all = cell2mat(db(2:end,4));
tone_noise_corr_all = cell2mat(db(2:end,5));
hc_sig_corr_all = cell2mat(db(2:end, 6));
hc_noise_corr_all = cell2mat(db(2:end,7));

avg_sig_corr = (tone_sig_corr_all + hc_sig_corr_all)/2;
hc_minus_t_noise_corr = hc_noise_corr_all - tone_noise_corr_all;

% remove nan from avg_sig_corr 
avg_sig_corr = avg_sig_corr(~isnan(avg_sig_corr));
hc_minus_t_noise_corr = hc_minus_t_noise_corr(~isnan(hc_minus_t_noise_corr));


% plot histogram of above 2
figure
subplot(1,2,1)
histogram(avg_sig_corr)
% xline mean and 0
hold on
xline(mean(avg_sig_corr))
xline(0)
hold off
% put mean in title
title(sprintf('avg sig corr, mean = %.4f', mean(avg_sig_corr)))
subplot(1,2,2)
histogram(hc_minus_t_noise_corr)
hold on
xline(mean(hc_minus_t_noise_corr))
xline(0)
hold off
% put mean in title
title(sprintf('avg sig corr, mean = %.4f', mean(hc_minus_t_noise_corr)))



% scatter of the above 2, with corr value in title
figure
scatter(avg_sig_corr, hc_minus_t_noise_corr)
title('avg sig corr vs hc minus t noise corr')
xlabel('avg sig corr')
ylabel('hc minus t noise corr')
% find corr val and put in title
[r,p] = corr(avg_sig_corr, hc_minus_t_noise_corr);
title(sprintf('r = %.2f, p = %.2f', r, p))

close all


% disp mean value of tone correlation
disp(sprintf('tone sig corr mean = %.4f', mean(tone_sig_corr_all)))
disp(sprintf('tone noise corr mean = %.4f', mean(tone_noise_corr_all)))
disp(sprintf('hc sig corr mean = %.4f', mean(hc_sig_corr_all)))
disp(sprintf('hc noise corr mean = %.4f', mean(hc_noise_corr_all)))

return 
% are each of the distr sig > 0
[h,p] = ttest(avg_sig_corr);
disp(sprintf('avg sig corr ~ 0: h = %d, p = %.4f', h, p))
[h,p] = ttest(hc_minus_t_noise_corr);
disp(sprintf('hc minus t noise corr ~ 0: h = %d, p = %.4f', h, p))
% tone sig corr > 0
[h,p] = ttest(tone_sig_corr_all);
disp(sprintf('tone sig corr ~ 0: h = %d, p = %.4f', h, p))
% hc sig corr > 0
[h,p] = ttest(hc_sig_corr_all);
disp(sprintf('hc sig corr ~ 0: h = %d, p = %.4f', h, p))
% tone noise corr > 0
[h,p] = ttest(tone_noise_corr_all);
disp(sprintf('tone noise corr ~ 0: h = %d, p = %.4f', h, p))
% hc noise corr > 0
[h,p] = ttest(hc_noise_corr_all);
disp(sprintf('hc noise corr ~ 0: h = %d, p = %.4f', h, p))
% ttest 2 btn tone sig corr and hc sig corr
[h,p] = ttest2(tone_sig_corr_all, hc_sig_corr_all);
disp(sprintf('tone sig corr ~ hc sig corr: h = %d, p = %.4f', h, p))
% ttest 2 btn tone noise corr and hc noise corr
[h,p] = ttest2(tone_noise_corr_all, hc_noise_corr_all);
disp(sprintf('tone noise corr ~ hc noise corr: h = %d, p = %.4f', h, p))