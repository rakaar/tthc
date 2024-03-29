clear;
rms_match_db_with_sig_bf = load('/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/PV/rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
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