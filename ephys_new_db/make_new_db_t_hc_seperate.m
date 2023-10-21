%% each row is a location
% tone and hc seperate
% ephys_db{unit_counter,1} = animal;
% ephys_db{unit_counter,2} = location_dir_name;
% ephys_db{unit_counter,3} = ch;
% ephys_db{unit_counter,4} = unit_path;
% ephys_db{unit_counter,5} = db;
% ephys_db{unit_counter,6} = spikes_all_freqs;

ephys_data_path = '/media/rka/Elements/tthc_ephys_all_33/hc';
animals_dir_path = dir(ephys_data_path);

% stim_type = 'TonePipSweep';
stim_type = 'HC';

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
            disp('INSIDE LOCATION')
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

                 if strcmp(protochol_type, stim_type)
                    % each channel
                    for ch=1:length(unit_data.unit_record_spike)
                        if isempty(unit_data.unit_record_spike(ch).negspiketime)
                            continue
                        end
                        spike_times = unit_data.unit_record_spike(ch).negspiketime.cl1;
                        if isempty(spike_times)
                            continue
                        end

                        if length(fieldnames(spike_times)) ~= 35
                            disp('353535353535353535353535353535')
                            disp(unit_path)
                            disp(length(fieldnames(spike_times)))
                            disp('35353535353535353535353535353535')
                            continue
                        end

                        spikes_all_freqs = cell(7,1);

                        for iter=1:5
                            for freq=1:7
                                cl1_index = (iter-1)*7 + freq;
                                spike_times_ms = spike_times.(strcat('iter', num2str(cl1_index)));
                                spikes_ms = zeros(1,2500);
                                spike_times_bin = fix(spike_times_ms*1000) + 1;
                                spikes_ms(1, spike_times_bin) = 1;

                                spikes_all_freqs{freq,1} = [spikes_all_freqs{freq,1}; spikes_ms];
                            end
                        end % end of iter
                        
                        ephys_db{unit_counter,1} = animal;
                        ephys_db{unit_counter,2} = location_dir_name;
                        ephys_db{unit_counter,3} = ch;
                        ephys_db{unit_counter,4} = unit_path;
                        ephys_db{unit_counter,5} = db;
                        ephys_db{unit_counter,6} = spikes_all_freqs;

                        unit_counter = unit_counter + 1;

                    end % end of ch
                 end % end of if
             end
        end
     end
end

if strcmp(stim_type, 'TonePipSweep')
        tone_db_stage1 = ephys_db;
        save('tone_db_stage1', 'tone_db_stage1')
else
    hc_db_stage1 = ephys_db;
    save('hc_db_stage1', 'hc_db_stage1')
end