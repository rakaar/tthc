clear ; close all;

% stim = 'TonePipSweep';
stim = 'HC';


% data_path = 'Q:\2p_anesthetised\pv_gcampflox';
% data_path = 'Q:\2p_anesthetised\thy1_gcamp_6f';
% data_path = 'G:\TTHC_2p_21032023_data\pv_gf_21032023';
% data_path = 'G:\TTHC_2p_21032023_data\sst_gf_21032023';
% data_path = 'G:\TTHC_2p_21032023_data\thy1_gcamp_6f_21032023';
% data_path = 'D:\TTHC_2p_21032023_data\thy1_gcamp_6f_21032023';
data_path = 'D:\TTHC_2p_21032023_data\sst_gf_21032023';
animals_dir_path1 = dir(data_path);



stage1_db = cell(1000,6);
counter = 1;
for i=3:length(animals_dir_path1)
    animal = animals_dir_path1(i).name;
    animal_dir_path = strcat(data_path, '\', animal);
    disp('---animal path is')
    disp(animal_dir_path)
    animal_dir_contents = dir(animal_dir_path);
    if length(animal_dir_contents) == 1
        continue
    end
     for j=3:length(animal_dir_contents)
        location_dir_name = animal_dir_contents(j).name;
        analysed_time_series_file_path = strcat(data_path, '\', animal, '\', location_dir_name, '\analysed\ONLINEANALYSISRESULTS');
        disp('::::::::::::::::file paths')
        disp(analysed_time_series_file_path)
        time_series_files_dir = dir(analysed_time_series_file_path);
        for f=3:length(time_series_files_dir)
            file = time_series_files_dir(f).name;
            fdata = load(strcat(analysed_time_series_file_path, '\', file));
            if ~isfield(fdata, 'Cell_dff')
                continue % if NO Cell_dff no point
            end
            
            % ====================== DB from here 
            if size(fdata.Cell_dff,2) ~= 35
                continue
            end

            %  protochol type
            if strcmp(fdata.PP_PARAMS.protocol.type, stim)
                for cell_no=1:size(fdata.Cell_dff,1)
                    stage1_db{counter,1} = animal;
                    stage1_db{counter,2} = location_dir_name;
                    stage1_db{counter,3} = cell_no;
                    stage1_db{counter,4} = strcat(analysed_time_series_file_path, '\', file);
                    stage1_db{counter,5} = fdata.PP_PARAMS.protocol.stim_protocol.level_hi;
    
                    all7_dff = cell(7,1);
                    for iter=1:5
                        for freq=1:7
                            index35 = (iter-1)*7 + freq;
                            all7_dff{freq,1} = [all7_dff{freq,1} squeeze(fdata.Cell_dff(cell_no,index35,:))];
                        end
                    end

                    for freq=1:7
                        all7_dff{freq,1} = all7_dff{freq,1}';
                    end
                    
                    stage1_db{counter,6} = all7_dff;
                    stage1_db{counter,7} = fdata.CellData.x(cell_no);
                    stage1_db{counter,8} = fdata.CellData.y(cell_no);
                    
                    counter = counter + 1;
                end % cell no
            end
            
            
            % ======================

        end
     end
end


if strcmp(stim,'TonePipSweep')
    tone_stage1 = stage1_db;
    save('tone_stage1','tone_stage1');
else
    hc_stage1 = stage1_db;
    save('hc_stage1', 'hc_stage1')
end
