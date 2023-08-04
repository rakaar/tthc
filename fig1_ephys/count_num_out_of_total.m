clear;close all;clc
% 1 - M,F 2 - 0:10:40, 3 - resp, 4 - Total
% ----------------- Tone ---------------------
data = load('E:\RK_code_TTHC\ephys_new_db\tone_db_stage1.mat').tone_db_stage1;

all_dbs = unique(cell2mat(data(:,5)));

num_data = zeros(2, length(all_dbs),2);
num_male = 0;
num_female = 0;

for u = 1:size(data,1)
    resp = data{u,6};
    spont = [];
    for f = 1:7
        spont = [spont; mean(resp{f,1}(:, 431:500),2)];
    end
    
    t_res = zeros(7,1);
    for f = 1:7
        f_res = mean(resp{f,1}(:, 501:570),2);
        t_res(f) = ttest2(f_res, spont);
    end

    animal_name = data{u,1};
    spl = data{u,5};
    
    if contains(animal_name, '_M')
        gender_index = 1;
        num_male = num_male + 1;
    elseif contains(animal_name, '_F')
        gender_index = 2;
        num_female = num_female + 1;
    end


    spl_index = find(all_dbs == spl);

    num_data(gender_index, spl_index, 2) =  num_data(gender_index, spl_index, 2) + 1;
    if sum(t_res) > 0
        num_data(gender_index, spl_index, 1) =  num_data(gender_index, spl_index, 1) + 1;
    end


end

disp('#### Tone Data ####')
disp('% of units responding to atleast 1 freq ')
table_data = num_data(:,:,1)./num_data(:,:,2)*100;
% disp(table_data)

% Convert matrix to table
T = array2table(table_data);

% Add column names
T.Properties.VariableNames =  string(all_dbs);

% Add row names
T.Properties.RowNames = {'Male', 'Female'};

% Display the table
disp(T)

disp('# of units responding to atleast 1 freq ')
table_data = squeeze(num_data(:,:,1));
% Convert matrix to table
T = array2table(table_data);

% Add column names
T.Properties.VariableNames =  string(all_dbs);

% Add row names
T.Properties.RowNames = {'Male', 'Female'};

% Display the table
disp(T)

disp('# of total units')
table_data = squeeze(num_data(:,:,2));

% Convert matrix to table
T = array2table(table_data);

% Add column names
T.Properties.VariableNames =  string(all_dbs);

% Add row names
T.Properties.RowNames = {'Male', 'Female'};

% Display the table
disp(T)
% ----------------------- HC -------------------------
data = load('E:\RK_code_TTHC\ephys_new_db\hc_db_stage1.mat').hc_db_stage1;

all_dbs = unique(cell2mat(data(:,5)));

num_data = zeros(2, length(all_dbs),2);
num_male = 0;
num_female = 0;
for u = 1:size(data,1)
    resp = data{u,6};
    spont = [];
    for f = 1:7
        spont = [spont; mean(resp{f,1}(:, 431:500),2)];
    end
    
    t_res = zeros(7,1);
    for f = 1:7
        f_res = mean(resp{f,1}(:, 501:570),2);
        t_res(f) = ttest2(f_res, spont);
    end

    animal_name = data{u,1};
    spl = data{u,5};
    
    if contains(animal_name, '_M')
        gender_index = 1;
        num_male = num_male + 1;
    elseif contains(animal_name, '_F')
        gender_index = 2;
        num_female = num_female + 1;
    end


    spl_index = find(all_dbs == spl);

    num_data(gender_index, spl_index, 2) =  num_data(gender_index, spl_index, 2) + 1;
    if sum(t_res) > 0
        num_data(gender_index, spl_index, 1) =  num_data(gender_index, spl_index, 1) + 1;
    end


end

disp('#### HC Data ####')
disp('% of units responding to atleast 1 freq ')
table_data = num_data(:,:,1)./num_data(:,:,2)*100;
% disp(table_data)

% Convert matrix to table
T = array2table(table_data);

% Add column names
T.Properties.VariableNames =  string(all_dbs);

% Add row names
T.Properties.RowNames = {'Male', 'Female'};

% Display the table
disp(T)

disp('# of units responding to atleast 1 freq ')
table_data = squeeze(num_data(:,:,1));
% Convert matrix to table
T = array2table(table_data);

% Add column names
T.Properties.VariableNames =  string(all_dbs);

% Add row names
T.Properties.RowNames = {'Male', 'Female'};

% Display the table
disp(T)

disp('# of total units')
table_data = squeeze(num_data(:,:,2));

% Convert matrix to table
T = array2table(table_data);

% Add column names
T.Properties.VariableNames =  string(all_dbs);

% Add row names
T.Properties.RowNames = {'Male', 'Female'};

% Display the table
disp(T)
