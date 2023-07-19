% Define your data
clear;clc
male_data = load('male_near_far.mat').male_near_far;
female_data = load('female_near_far.mat').female_near_far;

% ---- Taking frequencies
% Concatenate data into one vector
data = [male_data(:); female_data(:)];

% Define group arrays, with values repeated according to the size of the data
gender = [repmat({'Male'}, numel(male_data), 1); repmat({'Female'}, numel(female_data), 1)];

distance = repmat([repmat({'Near'}, 4, 1); repmat({'Far'}, 4, 1)], 2, 1); % Repeat for each gender

category = repmat({'HE'; 'HS'; 'NE'; 'NS'}, 2, 1); % For each distance
category = [category; category]; % Repeat for each gender

% Perform three-way ANOVA using 'anovan'
[p,t,stats] = anovan(data, {gender, distance, category}, 'varnames', {'Gender','Distance', 'Category'}, 'Model', 'interaction');
[c,m,h,gnames] = multcompare(stats, 'Dimension', [1 2]);

% --- Taking proportions
male_data(1,:) = male_data(1,:)./sum(male_data(1,:));
male_data(2,:) = male_data(2,:)./sum(male_data(2,:));


female_data(1,:) = female_data(1,:)./sum(female_data(1,:));
female_data(2,:) = female_data(2,:)./sum(female_data(2,:));

% Concatenate data into one vector
data = [male_data(:); female_data(:)];

% Define group arrays, with values repeated according to the size of the data
gender = [repmat({'Male'}, numel(male_data), 1); repmat({'Female'}, numel(female_data), 1)];

distance = repmat([repmat({'Near'}, 4, 1); repmat({'Far'}, 4, 1)], 2, 1); % Repeat for each gender

category = repmat({'HE'; 'HS'; 'NE'; 'NS'}, 2, 1); % For each distance
category = [category; category]; % Repeat for each gender

% Perform three-way ANOVA using 'anovan'
[p,t,stats] = anovan(data, {gender, distance, category}, 'varnames', {'Gender','Distance', 'Category'}, 'Model', 'interaction');
[c,m,h,gnames] = multcompare(stats, 'Dimension', [1 2]);