disp('Running he_hs.m')
he_hs;
disp('######## CHI Square test ##############')
disp('---Near far no normalize')
disp(near_far_no_normalize)

disp('---Near far normalized')
disp(near_far_counter(1,:)./sum(near_far_counter(1,:)))
disp(near_far_counter(2,:)./sum(near_far_counter(2,:)))

disp('condition checked - chi_square_stat > critical_value')
% Sample data
scenario1 = near_far_no_normalize(1,:); % proportions in scenario 1
scenario2 = near_far_no_normalize(2,:); % proportions in scenario 2

%% using cross tab
disp('====== using cross tab ======')
[~, chi2,p,~] = crosstab(scenario1,scenario2);
disp(['chi2 = ', num2str(chi2), ' p = ', num2str(p)])


%% using some another code chatgpt gave
% disp('--- some another code chatgpt gave ---')
% % Assume x and y are your categorical variables
% x = scenario1; % your data here
% y = scenario2; % your data here

% % Create cross-tabulation
% [C,~,~] = crosstab(x,y);

% % Calculate expected frequencies
% row_totals = sum(C,2);
% col_totals = sum(C,1);
% n = sum(row_totals);
% E = row_totals*col_totals / n;

% % Calculate Chi-square statistic
% X2 = sum(sum((C-E).^2 ./ E));

% % Calculate degrees of freedom
% [rows, cols] = size(C);
% df = (rows-1)*(cols-1);

% % Calculate p-value
% p = 1 - chi2cdf(X2, df);

% % Display p-value
% disp(['p is ', num2str(p)])
