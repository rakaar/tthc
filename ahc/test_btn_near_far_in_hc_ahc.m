clear;close all;clc;
load('ahc_near_far.mat')

load('hc_near_far.mat')
%%
disp('######## CHI Square test ##############')
disp('condition checked - chi_square_stat > critical_value')
% --- NEAR -------------
disp('------------ NEAR -------------')
% Sample data
scenario1 = ahc_near_far(1,:); % proportions in scenario 1
scenario2 = hc_near_far(1,:); % proportions in scenario 2

% Create contingency table
contingency_table = [scenario1; scenario2];

% Calculate row and column totals
row_totals = sum(contingency_table, 2);
col_totals = sum(contingency_table, 1);
total = sum(sum(contingency_table));

% Calculate expected frequencies
expected_freq = (row_totals * col_totals) ./ total;

% Compute chi-square statistic
chi_square_stat = sum(sum(((contingency_table - expected_freq).^2) ./ expected_freq));

% Calculate degrees of freedom
degrees_of_freedom = (size(contingency_table, 1) - 1) * (size(contingency_table, 2) - 1);

% Find critical value for desired level of significance (e.g., 0.05)
critical_value = chi2inv(0.95, degrees_of_freedom);

% Compare chi-square statistic with critical value
disp(['chi_square_stat = ', num2str(chi_square_stat), ' critical_value = ', num2str(critical_value)])

if chi_square_stat > critical_value
    fprintf('There is a significant difference in proportions between the two scenarios.\n');
else
    fprintf('There is no significant difference in proportions between the two scenarios.\n');
end

%% 
% --- FAR -------------
disp('---------- FAR ------------')
% Sample data
scenario1 = ahc_near_far(2,:); % proportions in scenario 1
scenario2 = hc_near_far(2,:); % proportions in scenario 2

% Create contingency table
contingency_table = [scenario1; scenario2];

% Calculate row and column totals
row_totals = sum(contingency_table, 2);
col_totals = sum(contingency_table, 1);
total = sum(sum(contingency_table));

% Calculate expected frequencies
expected_freq = (row_totals * col_totals) ./ total;

% Compute chi-square statistic
chi_square_stat = sum(sum(((contingency_table - expected_freq).^2) ./ expected_freq));

% Calculate degrees of freedom
degrees_of_freedom = (size(contingency_table, 1) - 1) * (size(contingency_table, 2) - 1);

% Find critical value for desired level of significance (e.g., 0.05)
critical_value = chi2inv(0.95, degrees_of_freedom);

% Compare chi-square statistic with critical value
disp(['chi_square_stat = ', num2str(chi_square_stat), ' critical_value = ', num2str(critical_value)])

if chi_square_stat > critical_value
    fprintf('There is a significant difference in proportions between the two scenarios.\n');
else
    fprintf('There is no significant difference in proportions between the two scenarios.\n');
end

%%
disp('####### FISCHER EXACT TEST ############')
disp('condition checked - p_value < alpha')
% Sample data
vec1 = ahc_near_far(1,:); % proportions in scenario 1
vec2 = hc_near_far(1,:); % proportions in scenario 2

disp('----- NEAR ----------')
% Create a 2x4 contingency table
contingency_table = [vec1; vec2];

% Call the myfisher24 function
p_value = myfisher24(contingency_table);

% Display p-value
fprintf('Fisher''s Exact Test p-value: %.4f\n', p_value);

% Compare p-value with desired level of significance (e.g., 0.05)
alpha = 0.05;
if p_value < alpha
    fprintf('There is a significant difference in proportions between the two scenarios.\n');
else
    fprintf('There is no significant difference in proportions between the two scenarios.\n');
end
%%
% Sample data
vec1 = ahc_near_far(2,:); % proportions in scenario 1
vec2 = hc_near_far(2,:); % proportions in scenario 2

disp('----- FAR ----------')

% Create a 2x4 contingency table
contingency_table = [vec1; vec2];

% Call the myfisher24 function
p_value = myfisher24(contingency_table);

% Display the p-value
fprintf('Fisher''s exact test p-value: %f\n', p_value);

% Compare p-value with desired level of significance (e.g., 0.05)
alpha = 0.05;
if p_value < alpha
    fprintf('There is a significant difference in proportions between the two scenarios.\n');
else
    fprintf('There is no significant difference in proportions between the two scenarios.\n');
end
