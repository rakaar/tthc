% db with format
% 1 - animal
% 2 -  loc
% 3 - ch
% 4 - t / hc / ahc
% 5 - spl
% 6 - freqs played
% 7 - rates
clear;
close all;
data_path = '/media/rka/Elements/aharmonic_01042023';
data_dir = dir(data_path);

stage1_db = cell(100,7);
counter = 1;

M_or_F = 'all';% M, F, all
for i=3:length(data_dir)
    animal = data_dir(i).name;
    if strcmp(M_or_F, 'M') && contains(animal, '_F')
        continue
    elseif strcmp(M_or_F, 'F') && contains(animal, '_M')
        continue
    end
    animal_path = strcat(data_dir(i).folder, '/', data_dir(i).name);
    animal_path_dir = dir(animal_path);
    for j=3:length(animal_path_dir)
        loc_name = animal_path_dir(j).name;
        if contains(loc_name, 'location')
            loc_path = strcat(animal_path_dir(j).folder, '/', animal_path_dir(j).name, '/Single_units');
            units_dir = dir(loc_path);
           
            for u=3:length(units_dir)
                fpath = strcat(units_dir(u).folder, '/', units_dir(u).name);
                
                PP_PARAMS = load(fpath).PP_PARAMS;
                
                if strcmp(PP_PARAMS.protocol.type, 'NoisePip')
                    continue
                end
                spl = PP_PARAMS.protocol.stim_protocol.level_lo;
                freqs_played = PP_PARAMS.AUD_IMG_STIM.STIMS.freqs;
                protochol_type = PP_PARAMS.protocol.type;
                if ~isfield(PP_PARAMS.protocol.stim_protocol, 'tthc_ahc_check')
                    ahc_check = 0;
                else
                    ahc_check = PP_PARAMS.protocol.stim_protocol.tthc_ahc_check;
                end

                if strcmp(protochol_type, 'TonePipSweep')
                     protochol_num = 0; % T
                elseif strcmp(protochol_type, 'HC')
                    if ahc_check == 0
                        protochol_num = 1; % HC
                    elseif ahc_check == 1
                        protochol_num = 2; % A HC
                    end
                end

                unit_record_spike = load(fpath).unit_record_spike;
                
                for c=1:length(unit_record_spike)
                    negspiketime = unit_record_spike(c).negspiketime;
                    if ~isempty(negspiketime)
                        cl1 = negspiketime.cl1;
                        if length(fields(cl1)) == 65 && protochol_num <= 1
                            spikes = cell(13,1);
                            for iter=1:5
                                for freq=1:13
                                     iter_ind = (iter-1)*13 + freq;
                                     spk_times = cl1.(strcat('iter', num2str(iter_ind)));
                                     spk_ms_bins = zeros(1,2500);
                                     spk_ms_bins( fix(spk_times*1000) + 1 ) = 1;
                                     spikes{freq,1} = [spikes{freq,1}; spk_ms_bins];
                                end % freq
                            end % iter
                            stage1_db{counter,1} = animal;
                            stage1_db{counter,2} = loc_name;
                            stage1_db{counter,3} = c;
                            stage1_db{counter,4} = protochol_num;
                            stage1_db{counter,5} = spl;
                            stage1_db{counter,6} = freqs_played;
                            stage1_db{counter,7} = spikes;
                            counter = counter + 1;
                        elseif length(fields(cl1)) == 30 && protochol_num == 2
                            spikes = cell(6,1);
                            for iter=1:5
                                for freq=1:6
                                     iter_ind = (iter-1)*6 + freq;
                                     spk_times = cl1.(strcat('iter', num2str(iter_ind)));
                                     spk_ms_bins = zeros(1,2500);
                                     spk_ms_bins( fix(spk_times*1000) + 1 ) = 1;
                                     spikes{freq,1} = [spikes{freq,1}; spk_ms_bins];
                                end % freq
                            end % iter
                            stage1_db{counter,1} = animal;
                            stage1_db{counter,2} = loc_name;
                            stage1_db{counter,3} = c;
                            stage1_db{counter,4} = protochol_num;
                            stage1_db{counter,5} = spl;
                            stage1_db{counter,6} = freqs_played;
                            stage1_db{counter,7} = spikes;
                            counter = counter + 1;
                        else
                            disp(fpath)

                        end
                    end % is not empty negspiketime
                end % c
            end % u
            
        end % if locname location 
    end % j  
end % i

%%
rows_to_del = [];
for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 1 || stage1_db{u,4} == 0
        freqs = stage1_db{u,6};
        if freqs(13) < 20e3
            rows_to_del = [rows_to_del u];
        end
    end
end % u

%%  
stage1_db(rows_to_del, :) = [];
%%


save('stage1_db.mat', 'stage1_db')