% Make 2p AHC 
clear;
data_path = 'E:\ahc_2p';

stage1_db = cell(1000,6);
% 1 - animal name
% 2 - location
% 3 - stimulus - 0:T,1:H,2:AHC
% 4 - db SPL
% 5 - responses
% 6 - filepath

counter = 1;

animals_dir = dir(data_path);
for i=3:length(animals_dir)
    animal = animals_dir(i).name;
    animal_path = strcat(data_path, '\', animal);
    disp(['animal path is = ' animal_path])
    dates_dir = dir(animal_path);
    for j=3:length(dates_dir)
        date = dates_dir(j).name;
        analysed_path = strcat(animal_path, '\', date, '\analysed');
        disp([' analysed path is = ' analysed_path])
        analysed_dir = dir(analysed_path);
        for k=3:length(analysed_dir)
            location = analysed_dir(k).name;
            location_path = strcat(analysed_path, '\', location);
            disp(['     location path is = ' location_path])
            if contains(location, 'AVOID')
                continue
            end
            location_dir = dir(location_path);
            for m=3:length(location_dir)
                file = location_dir(m).name;
                file_path = strcat(location_path, '\', file);
                % if its not a MAT file, skip
                if ~endsWith(file_path, '.mat')
                    continue
                end
                
                disp(['         file path is = ' file_path])
                fdata = load(file_path);

                if strcmp(fdata.PP_PARAMS.protocol.type,'NoisePip')
                   continue
                end

                if strcmp(fdata.PP_PARAMS.protocol.type,'TonePipSweep')
                    stimulus = 0;
                elseif strcmp(fdata.PP_PARAMS.protocol.type,'HC') && fdata.PP_PARAMS.protocol.stim_protocol.tthc_ahc_check == 0
                    stimulus = 1;
                elseif strcmp(fdata.PP_PARAMS.protocol.type,'HC') && fdata.PP_PARAMS.protocol.stim_protocol.tthc_ahc_check == 1
                    stimulus = 2;
                end

                stage1_db{counter,1} = animal;
                stage1_db{counter,2} = location;
                stage1_db{counter,3} = stimulus;
                stage1_db{counter,4} = fdata.PP_PARAMS.protocol.stim_protocol.level_lo;                
                stage1_db{counter,5} = fdata.Cell_dff;
                stage1_db{counter,6} = file_path;
                disp(['stimulus is = ' num2str(stimulus), ' counter is = ' num2str(counter)])
                counter = counter + 1;                

            end
        end % k
    end
end % i


save('stage1_db.mat', 'stage1_db')