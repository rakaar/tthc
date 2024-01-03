clear;clc;
rms_match_file_path = '/media/rka/Elements/RK_E_folder_TTHC_backup/RK TTHC Data/Thy/rms_match_db_with_sig_bf.mat';
rms_match_db_with_sig_bf = load(rms_match_file_path).rms_match_db_with_sig_bf;

db = rms_match_db_with_sig_bf;

roi_num_map = containers.Map;
combiner = '***';

for u = 1:size(db,1)
    animal = db{u,1};
    loc = db{u,2};
    spl = num2str(db{u,6});

    keyname = [animal,combiner,loc,combiner,spl];

    if roi_num_map.isKey(keyname)
        roi_num_map(keyname) = roi_num_map(keyname) + 1;
    else
        roi_num_map(keyname) = 1;
    end % if
end % u

all_keys = keys(roi_num_map);
disp(['Num of ROIs ' num2str(length(all_keys))]);

num_neurons_arr = zeros(length(all_keys),1);
for u = 1:length(all_keys)
    keyname = all_keys{u};
    num_neurons_arr(u) = roi_num_map(keyname);
end % u

% mean and sd of num neurons
disp(['Mean num of neurons ' num2str(mean(num_neurons_arr))]);
disp(['SD num of neurons ' num2str(std(num_neurons_arr))]);