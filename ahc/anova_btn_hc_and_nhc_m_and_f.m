non_hc_data = load('non_hc_near_far.mat').near_far_data;
hc_data = load('hc_near_far.mat').near_far_data;

% ---- Taking frequencies
% Concatenate data into one vector
data = [non_hc_data(:); hc_data(:)];

% Define group arrays, with values repeated according to the size of the data
non_hc_or_hc = [repmat({'Non HC'}, numel(non_hc_data), 1); repmat({'HC'}, numel(hc_data), 1)];

distance = repmat([repmat({'Near'}, 4, 1); repmat({'Far'}, 4, 1)], 2, 1); % Repeat for each 

category = repmat({'HE'; 'HS'; 'NE'; 'NS'}, 2, 1); % For each distance
category = [category; category]; % Repeat for each non_hc_or_hc

% Perform three-way ANOVA using 'anovan'
[p,t,stats] = anovan(data, {non_hc_or_hc, distance, category}, 'varnames', {'Non HC vs HC','Distance', 'Category'}, 'Model', 'interaction');
[c,m,h,gnames] = multcompare(stats, 'Dimension', [1 2]);

% --- Taking proportions
non_hc_data(1,:) = non_hc_data(1,:)./sum(non_hc_data(1,:));
non_hc_data(2,:) = non_hc_data(2,:)./sum(non_hc_data(2,:));


hc_data(1,:) = hc_data(1,:)./sum(hc_data(1,:));
hc_data(2,:) = hc_data(2,:)./sum(hc_data(2,:));

% Concatenate data into one vector
data = [non_hc_data(:); hc_data(:)];

% Define group arrays, with values repeated according to the size of the data
non_hc_or_hc = [repmat({'Non HC'}, numel(non_hc_data), 1); repmat({'HC'}, numel(hc_data), 1)];

distance = repmat([repmat({'Near'}, 4, 1); repmat({'Far'}, 4, 1)], 2, 1); % Repeat for each non_hc_or_hc

category = repmat({'HE'; 'HS'; 'NE'; 'NS'}, 2, 1); % For each distance
category = [category; category]; % Repeat for each non_hc_or_hc

% Perform three-way ANOVA using 'anovan'
[p,t,stats] = anovan(data, {non_hc_or_hc, distance, category}, 'varnames', {'Non HC vs HC','Distance', 'Category'}, 'Model', 'interaction');
[c,m,h,gnames] = multcompare(stats, 'Dimension', [1 2]);