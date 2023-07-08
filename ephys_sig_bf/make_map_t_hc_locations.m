loc_map = containers.Map;
stim = 'hc';
% stim = 'tone';
if strcmp(stim, 'tone')
    units_db = load('ephys_tone_33_5_and_6_sig_7_rates_8_bf.mat').ephys_tone_33_5_and_6_sig_7_rates_8_bf;
    n_units = 359;
elseif strcmp(stim, 'hc')
    units_db = load('ephys_hc_33_5_and_6_sig_7_rates_8_bf.mat').ephys_hc_33_5_and_6_sig_7_rates_8_bf;
    n_units = 333;
end

for u=1:n_units
    animal_name = units_db{u,1};
    location_name = units_db{u,2};
    channel_name = num2str(units_db{u,3});
    combiner = '***';

    combined_loc = strcat(animal_name, combiner, location_name, combiner, channel_name);

    loc_map(combined_loc) = u;
end

if strcmp(stim, 'tone')
    tone_loc_map = loc_map;
    save('tone_loc_map.mat', 'tone_loc_map');
elseif strcmp(stim, 'hc')
    hc_loc_map = loc_map;
    save('hc_loc_map.mat', 'hc_loc_map');
end

