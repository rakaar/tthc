clear;clc; close all;
rms_match_db = load('E:\RK_E_folder_TTHC_backup\RK TTHC Data\SingleUnit\rms_match_db.mat').rms_match_db;

dbs = [0,10,20,30,40];
num_of_units = zeros(2, length(dbs), 3);
% 1,2 - M,F
% 3 - Only T, Only HC, Both T and HC

for u = 1:size(rms_match_db,1)
    animal_name = rms_match_db{u,1};
    spl = rms_match_db{u,4};

    if contains(animal_name, '_M')
        gender_index = 1;
    elseif contains(animal_name, '_F')
        gender_index = 2;
    end

    spl_index = find(dbs == spl);

    if rms_match_db{u,12} ~= -1 && rms_match_db{u,13} == -1
        resp_index = 1;
    elseif rms_match_db{u,12} == -1 && rms_match_db{u,13} ~= -1
        resp_index = 2;
    elseif rms_match_db{u,12} ~= -1 && rms_match_db{u,13} ~= -1
        resp_index = 3;
    end


    num_of_units(gender_index, spl_index, resp_index) = num_of_units(gender_index, spl_index, resp_index) + 1;
end 


% Print Male data as table
male_data = squeeze(num_of_units(1,:,:)); % length(dbs) x 3
disp('Male data')
disp(male_data)

% Print Female data
female_data = squeeze(num_of_units(2,:,:));
disp('Female data')
disp(female_data)
