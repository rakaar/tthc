ephys_data_path = '/media/rka/Elements/tthc_ephys_all_33/hc';
animals_dir_path = dir(ephys_data_path);



tone_noise_corr_db = cell(100,5);
hc_noise_corr_db = cell(100,5);

tone_counter = 1;
hc_counter = 1;

ephys_db = cell(500,3);

unit_counter = 1;

for i=3:length(animals_dir_path)
    animal= animals_dir_path(i).name;
    animal_dir_path = strcat(ephys_data_path, '/', animal);
    disp('---animal path is')
    disp(animal_dir_path)
    animal_dir_contents = dir(animal_dir_path);
     for j=3:length(animal_dir_contents)
        location_dir_name = animal_dir_contents(j).name;
       
        if contains(location_dir_name, 'location')
            location_dir_path = strcat(animal_dir_path, '/', location_dir_name, '/Single_units');
            disp('location is:-')
            disp(location_dir_path)
            units_dir = dir(location_dir_path);

             for u=3:length(units_dir)
                unit_filename = units_dir(u).name;
                unit_path = strcat(location_dir_path, '/', unit_filename);
                unit_data = load(unit_path);
                
                protochol_type = unit_data.PP_PARAMS.protocol.type;
                % skip VOCAL types, not our data
                if strcmp(protochol_type, 'VOCAL')
                    continue
                end

                db = unit_data.PP_PARAMS.protocol.stim_protocol.level_hi;
                noise_vecs = [];
                resp_channels = [];
                for ch=1:length(unit_data.unit_record_spike)
                    if isempty(unit_data.unit_record_spike(ch).negspiketime)
                        continue
                    end
                    sp_times = unit_data.unit_record_spike(ch).negspiketime.cl1;
                    if length(fieldnames(sp_times)) ~= 35
                        continue
                    end

                    resp_channels = [resp_channels ch];
        	        all_35_res = zeros(35,1);
                    for iter=1:35
                        times = sp_times.(strcat('iter', num2str(iter)));
                        spikes = zeros(2500,1);
                        spikes(fix(times*1000) + 1) = 1;
                        res = mean(spikes(501:570));
                        all_35_res(iter) = res;
                    end
                    mean_across_iters = mean(reshape(all_35_res, 7,5),  2);
                    all_35_reshaped = reshape(all_35_res, 7,5);

                    mean_like_matrix = zeros(7,5);
                    for mmm=1:7
                        mean_like_matrix(mmm,:) = mean_across_iters(mmm);
                    end

                    noise_mat = all_35_reshaped - mean_like_matrix;
                    noise_vecs = [noise_vecs reshape(noise_mat, 35,1)];
                end
                corr_matrix = corrcoef(noise_vecs);
                if strcmp(protochol_type, 'TonePipSweep')
                    tone_noise_corr_db{tone_counter,1} = animal;
                    tone_noise_corr_db{tone_counter,2} = location_dir_name;
                    tone_noise_corr_db{tone_counter,3} = unit_path;
                    tone_noise_corr_db{tone_counter,4} = db;
                    tone_noise_corr_db{tone_counter,5} = corr_matrix;
                    tone_noise_corr_db{tone_counter,6} = resp_channels;
                    tone_counter = tone_counter + 1;
                elseif strcmp(protochol_type, 'HC')
                    hc_noise_corr_db{hc_counter,1} = animal;
                    hc_noise_corr_db{hc_counter,2} = location_dir_name;
                    hc_noise_corr_db{hc_counter,3} = unit_path;
                    hc_noise_corr_db{hc_counter,4} = db;
                    hc_noise_corr_db{hc_counter,5} = corr_matrix;
                    hc_noise_corr_db{hc_counter,6} = resp_channels;
                    hc_counter = hc_counter + 1;
                end
             end % u
        end
     end
end


save('tone_noise_corr_db', 'tone_noise_corr_db')
save('hc_noise_corr_db', 'hc_noise_corr_db')
