clear;close all;clc
% 1 - M,F 2 - 0:10:40, 3 - resp, 4 - Total
% ----------------- Tone ---------------------
data = load('tone_stage1.mat').tone_stage1;


male_data = containers.Map;
female_data = containers.Map;

combiner = '***';

for u = 1:size(data,1)
    resp = data{u,6};
    spont = [];
    for f = 1:7
        spont = [spont; mean(resp{f,1}(:, 5:9),2)];
    end
    
    t_res = zeros(7,1);
    for f = 1:7
        f_res = mean(resp{f,1}(:, 10:14),2);
        if mean(f_res) > mean(spont)
            t_res(f) = ttest2(f_res, spont);
        end
    end

    animal_name = data{u,1};
    loc = num2str(data{u,2});
    channel = num2str(data{u,3});
    

    combine_name = strcat(animal_name, combiner, loc,  combiner, channel);
    if contains(animal_name, '_M')
        if isKey(male_data, combine_name)
            male_data(combine_name) = male_data(combine_name) + sum(t_res);
        else
            male_data(combine_name) = sum(t_res);
        end
    elseif contains(animal_name, '_F')
        if isKey(female_data, combine_name)
            female_data(combine_name) = female_data(combine_name) + sum(t_res);
        else
            female_data(combine_name) = sum(t_res);
        end
    end
end

disp('#### Tone Data ####')
disp('---Male---')
gender_data = male_data;
data_keys = keys(gender_data);
disp(['Total Number of units ' num2str(length(data_keys))])
n = 0;
% for check
arr_num_responding = [];
for k = 1:length(data_keys)
    arr_num_responding = [arr_num_responding gender_data(data_keys{k})];
    if gender_data(data_keys{k}) > 0
        n = n + 1;
    end
end
disp(['# Responding to atleast one freq in atleast one db ' num2str(n)])
disp('---- Female -----')
gender_data = female_data;
data_keys = keys(gender_data);
disp(['Total Number of units ' num2str(length(data_keys))])
n = 0;
for k = 1:length(data_keys)
    if gender_data(data_keys{k}) > 0
        n = n + 1;
    end
end
disp(['# Responding to atleast one freq in atleast one db ' num2str(n)])


% ----------------------- HC -------------------------
data = load('hc_stage1.mat').hc_stage1;


male_data = containers.Map;
female_data = containers.Map;

combiner = '***';

for u = 1:size(data,1)
    resp = data{u,6};
    spont = [];
    for f = 1:7
        spont = [spont; mean(resp{f,1}(:, 5:9),2)];
    end
    
    t_res = zeros(7,1);
    for f = 1:7
        f_res = mean(resp{f,1}(:, 10:14),2);
        if mean(f_res) > mean(spont)
            t_res(f) = ttest2(f_res, spont);
        end
    end

    animal_name = data{u,1};
    loc = num2str(data{u,2});
    channel = num2str(data{u,3});
    

    combine_name = strcat(animal_name, combiner, loc,  combiner, channel);
    if contains(animal_name, '_M')
        if isKey(male_data, combine_name)
            male_data(combine_name) = male_data(combine_name) + sum(t_res);
        else
            male_data(combine_name) = sum(t_res);
        end
    elseif contains(animal_name, '_F')
        if isKey(female_data, combine_name)
            female_data(combine_name) = female_data(combine_name) + sum(t_res);
        else
            female_data(combine_name) = sum(t_res);
        end
    end
end

disp('#### HC Data ####')
disp('---Male---')
gender_data = male_data;
data_keys = keys(gender_data);
disp(['Total Number of units ' num2str(length(data_keys))])
n = 0;
for k = 1:length(data_keys)
    if gender_data(data_keys{k}) > 0
        n = n + 1;
    end
end
disp(['# Responding to atleast one freq in atleast one db ' num2str(n)])
disp('---- Female -----')
gender_data = female_data;
data_keys = keys(gender_data);
disp(['Total Number of units ' num2str(length(data_keys))])
n = 0;
for k = 1:length(data_keys)
    if gender_data(data_keys{k}) > 0
        n = n + 1;
    end
end
disp(['# Responding to atleast one freq in atleast one db ' num2str(n)])