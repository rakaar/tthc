tone_loc_map = load('tone_loc_map.mat').tone_loc_map;
hc_loc_map = load('hc_loc_map.mat').hc_loc_map;

tone_db = load('ephys_tone_33_5_and_6_sig_7_rates_8_bf.mat').ephys_tone_33_5_and_6_sig_7_rates_8_bf;
hc_db = load('ephys_hc_33_5_and_6_sig_7_rates_8_bf.mat').ephys_hc_33_5_and_6_sig_7_rates_8_bf;

n_units = 333; % hc

rms_match_db = cell(500,13);
rms_counter = 1;

for u=1:n_units
    animal_name = hc_db{u,1};
    location_name = hc_db{u,2};
    channel_name = num2str(hc_db{u,3});
    combiner = '***';

    combined_loc = strcat(animal_name, combiner, location_name, combiner, channel_name);
    if isKey(tone_loc_map,combined_loc)
        tone_db_index = tone_loc_map(combined_loc);

        tone_rates = tone_db{tone_db_index, 4}; % 5 x 2
        hc_rates = hc_db{u,4}; % 10 x 2

        tone_db_lvls = cell2mat(tone_rates(:,1));% 5 x 1
        hc_db_lvls = cell2mat(hc_rates(:,1)); % 10 x 1
        
        tone_sig = tone_db{tone_db_index,5};
        hc_sig = hc_db{u,5};
        
        for td=1:length(tone_db_lvls)
            t_db_lvl = tone_db_lvls(td);
            rms_match_hc_db_lvl = t_db_lvl + 5;
            rms_match_hc_db_lvl_index = find(hc_db_lvls == rms_match_hc_db_lvl);

            tone_lvl_sig_mat = tone_sig(:,td);
            hc_lvl_sig_mat = hc_sig(:,rms_match_hc_db_lvl_index);

            if anynan(tone_lvl_sig_mat) || anynan(hc_lvl_sig_mat)
                continue
            end

            if sum(tone_lvl_sig_mat) + sum(hc_lvl_sig_mat) == 0
                continue
            end

            tone_lvl_res_full = tone_rates{td,2};
            hc_lvl_res_full = hc_rates{rms_match_hc_db_lvl_index,2};

            tone_lvl_res_stim = tone_db{tone_db_index,7}(:,td);
            hc_lvl_res_stim = hc_db{u,7}(:,rms_match_hc_db_lvl_index);
            
            
            sig_indices = find(tone_lvl_sig_mat == 1);
            if isempty(sig_indices)
                tone_bf = -1;
            else
                sig_rates = tone_lvl_res_stim(sig_indices);
                [~, index] = max(sig_rates);
                tone_bf = sig_indices(index);
            end

            sig_indices = find(hc_lvl_sig_mat == 1);
            if isempty(sig_indices)
                hc_bf = -1;
            else
                sig_rates = hc_lvl_res_stim(sig_indices);
                [~, index] = max(sig_rates);
                hc_bf = sig_indices(index);
            end



           rms_match_db{rms_counter,1} = animal_name;
           rms_match_db{rms_counter,2} = location_name;
           rms_match_db{rms_counter,3} = channel_name;
           rms_match_db{rms_counter,4} = t_db_lvl;
           rms_match_db{rms_counter,5} = rms_match_hc_db_lvl;
           rms_match_db{rms_counter,6} = tone_lvl_res_full;
           rms_match_db{rms_counter,7} = hc_lvl_res_full;
           rms_match_db{rms_counter,8} = tone_lvl_sig_mat;
           rms_match_db{rms_counter,9} = hc_lvl_sig_mat;
           rms_match_db{rms_counter,10} = tone_lvl_res_stim;
           rms_match_db{rms_counter,11} = hc_lvl_res_stim;
           rms_match_db{rms_counter,12} = tone_bf;
           rms_match_db{rms_counter,13} = hc_bf;

           rms_counter = rms_counter + 1;

        end % end of td
    end % if isKey
end % end of u
