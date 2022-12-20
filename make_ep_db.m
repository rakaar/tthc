ephys_data_path = 'F:\RK_code_TTHC\ephys_arranged';
animals_dir_path = dir(ephys_data_path);
unit_counter = 1;

ephys_rms_match_db = cell(500, 20);
% 1500 max rows
% cols: 1,2- HC file,tone file, 3,4 - HC(d),tone(d-5) intensity,
% 5-11 : HC res, 12-18: Tone res, 19-sig in HC,sig in tone
% 29 - animal-location, 30- channel number


for i=3:length(animals_dir_path)
    animal= animals_dir_path(i).name;
    animal_dir_path = strcat(ephys_data_path, '\', animal);
    disp('---animal path is')
    disp(animal_dir_path)
    animal_dir_contents = dir(animal_dir_path);
    for j=3:length(animal_dir_contents)
        location_dir_name = animal_dir_contents(j).name;
       
        if contains(location_dir_name, 'location')
            location_dir_path = strcat(animal_dir_path, '\', location_dir_name, '\Single_units');
            disp('location is:-')
            disp(location_dir_path)
            units_dir = dir(location_dir_path);
            
            hc_map = containers.Map; % file - T/HC - intensity
            for d=0:5:45
                hc_map(num2str(d)) = cell(5,1);
                hc_map(strcat(num2str(d), '-', 'counter')) = 1;
            end
            tone_map = containers.Map; % file - T/HC - intensity
            for d=0:5:45
                tone_map(num2str(d)) = cell(5,1);
                tone_map(strcat(num2str(d), '-', 'counter')) = 1;
            end

            for u=3:length(units_dir)
                unit_filename = units_dir(u).name;
                unit_path = strcat(location_dir_path, '\', unit_filename);
                unit_data = load(unit_path);
                
                protochol_type = unit_data.PP_PARAMS.protocol.type;
                % skip VOCAL types, not our data
                if strcmp(protochol_type, 'VOCAL')
                    continue
                end
                db = unit_data.PP_PARAMS.protocol.stim_protocol.level_hi;
                if strcmp(protochol_type, 'HC')
                    current_files = hc_map(num2str(db));
                    current_files{hc_map(strcat(num2str(db), '-', 'counter')), 1} = unit_path;
                    hc_map(num2str(db)) = current_files; 
                    hc_map(strcat(num2str(db), '-', 'counter')) = hc_map(strcat(num2str(db), '-', 'counter')) + 1;
                elseif strcmp(protochol_type, 'TonePipSweep')
                    current_files = tone_map(num2str(db));
                    current_files{tone_map(strcat(num2str(db), '-', 'counter')), 1} = unit_path;
                    tone_map(num2str(db)) = current_files;
                    tone_map(strcat(num2str(db), '-', 'counter')) = tone_map(strcat(num2str(db), '-', 'counter')) + 1;
                end
                
                % for each channels - filename, DB, unit = unit + 1;

            end % end of a u, unit
            rms_matched_spike_rates = cell(10,16,14); % 10 intensitites,  16 channels, 14 = 7 hc sp rates, 7 tone sp rates 
            for d=5:5:50 % HC db levels
                if ~isKey(hc_map, num2str(d)) || hc_map(strcat( num2str(d),'-counter'  )) == 1
                    continue % no data for that db at hc
                end
                if ~isKey(tone_map, num2str(d-5))  || tone_map(strcat( num2str(d-5),'-counter'  )) == 1  
                    continue % NO RMS match of tone
                end
                
                for f=1:hc_map(  strcat(num2str(d), '-counter')  ) - 1
                    files = hc_map(num2str(d));
                    file = files{f,1};
                    unit_record_spike = load(file).unit_record_spike;
                    for ch=1:16
                       if isempty(unit_record_spike(ch).negspiketime)
                            continue
                       end

                       all_iter_responses = unit_record_spike(ch).negspiketime.cl1;
                       for iter=1:5
                           for freq=1:7
                               index_in_cl1 = (iter-1)*5 + freq;
                               res = all_iter_responses.(strcat('iter', num2str(index_in_cl1)));
                               if isempty(res)
                                continue
                               end
                               spikes_ms = fix(res*1000) + 1;
                               spikes = zeros(1,2500);
                               spikes(1,spikes_ms) = 1;
                               rms_matched_spike_rates{d/5,ch,freq} = [rms_matched_spike_rates{d/5,ch,freq}; spikes];
                           end % end of freq

                       end % end of iter
                    end % end of ch
                     
                end % end of f in freq


                for f=1:tone_map( strcat(num2str(d-5),'-counter')  ) - 1
                             files = tone_map(num2str(d-5));
                            file = files{f,1};
                            unit_record_spike = load(file).unit_record_spike;
                            for ch=1:16
                               if isempty(unit_record_spike(ch).negspiketime)
                                    continue
                               end
        
                               all_iter_responses = unit_record_spike(ch).negspiketime.cl1;
                               for iter=1:5
                                   for freq=1:7
                                       index_in_cl1 = (iter-1)*5 + freq;
                                       res = all_iter_responses.(strcat('iter', num2str(index_in_cl1)));
                                       if isempty(res)
                                        continue
                                       end
                                       spikes_ms = fix(res*1000) + 1;
                                       spikes = zeros(1,2500);
                                       spikes(1,spikes_ms) = 1;
                                       rms_matched_spike_rates{d/5,ch,freq+7} = [rms_matched_spike_rates{d/5,ch,freq+7}; spikes];
                                   end % end of freq
        
                               end % end of iter
                            end % end of ch
                end % end of f in tone
            end % end of d (intensity)


            for d=1:10
                if ~isKey(hc_map, num2str(d*5)) || hc_map(strcat( num2str(d*5),'-counter'  )) == 1
                    continue % no data for that db at hc
                end
                if ~isKey(tone_map, num2str((d*5)-5))  || tone_map(strcat( num2str((d*5)-5),'-counter'  )) == 1  
                    continue % NO RMS match of tone
                end

                
                for ch=1:16
                    ephys_rms_match_db{unit_counter,1} = hc_map(num2str(d*5));
                    ephys_rms_match_db{unit_counter,2} = tone_map(num2str((d*5)-5));
        
                    ephys_rms_match_db{unit_counter,3}  = d*5;
                    ephys_rms_match_db{unit_counter,4}  = (d*5)-5;

                    ephys_rms_match_db{unit_counter,30}  = ch;
                    ephys_rms_match_db{unit_counter,29}  = strcat(animal, '-', location_dir_name);

                    num_of_freqs_with_no_res = 0;
                     for freq=1:14
                         if isempty(rms_matched_spike_rates{d,ch,freq})
                             num_of_freqs_with_no_res = num_of_freqs_with_no_res + 1;
                         else
                             ephys_rms_match_db{unit_counter,freq+4} = rms_matched_spike_rates{d,ch,freq};
                         end
                     end

                     
                     if num_of_freqs_with_no_res == 14
                        continue
                     else 
                         unit_counter = unit_counter + 1;
                     end
                     
                    
                end
            end % end of d=1:10

        end % end of if 'location' is in folder name
    end % end of locations
end % end of animals
