all_corr_vals = load('all_corr_vals').all_corr_vals;

% all_corr_vals = {
%     'keyname', 'unit1', 'unit2', 'tone_sig_corr', 'tone_noise_corr', 'hc_sig_corr', 'hc_noise_corr';
    
% };

tone_sig_corr = cell2mat(all_corr_vals(2:end,4));
tone_noise_corr = cell2mat(all_corr_vals(2:end,5));
hc_sig_corr = cell2mat(all_corr_vals(2:end,6));
hc_noise_corr = cell2mat(all_corr_vals(2:end,7));

% plot tone sig corr vs hc sig corr
figure;
scatter(tone_sig_corr, hc_sig_corr);
xlabel('tone sig corr');
ylabel('hc sig corr');
title('tone sig corr vs hc sig corr');


% plot tone_sig_corr vs tone_noise_corr scatter
figure;
scatter(cell2mat(all_corr_vals(2:end,4)), cell2mat(all_corr_vals(2:end,5)));
xlabel('tone sig corr');
ylabel('tone noise corr');
title('tone sig corr vs tone noise corr');

prod = tone_sig_corr.*tone_noise_corr;
same_sign = find(prod > 0);
opp_sign = find(prod < 0);
tone_sig_corr_same = tone_sig_corr(same_sign);
tone_noise_corr_same = tone_noise_corr(same_sign);



% Fit a line to the data
coefficients = polyfit(tone_sig_corr_same, tone_noise_corr_same, 1);

% Get the line equation
slope = coefficients(1);
intercept = coefficients(2);
line_equation = sprintf('y = %.2fx + %.2f', slope, intercept);

% Find the goodness of fit
y_predicted = polyval(coefficients, tone_sig_corr_same);
residuals = tone_noise_corr_same - y_predicted;
mean_squared_error = mean(residuals.^2);
r_squared = 1 - (mean_squared_error / var(tone_noise_corr_same));

% Display the line equation and goodness of fit
disp(line_equation);
disp(['R-squared: ', num2str(r_squared)]);
[h,p] = corr(tone_sig_corr_same, tone_noise_corr_same)
figure;
scatter(tone_sig_corr_same, tone_noise_corr_same);
hold on;
plot(tone_sig_corr_same, y_predicted, 'r', 'LineWidth', 2);
hold off;
xlabel('tone sig corr');
ylabel('tone noise corr');
title(sprintf('Scatter Plot with Line Fit\n%s\nR-squared: %.4f', line_equation, r_squared));


% -------- opp sign

tone_sig_corr_opp = tone_sig_corr(opp_sign);
tone_noise_corr_opp = tone_noise_corr(opp_sign);

% Fit a line to the data
coefficients = polyfit(tone_sig_corr_opp, tone_noise_corr_opp, 1);

% Get the line equation
slope = coefficients(1);
intercept = coefficients(2);
line_equation = sprintf('y = %.2fx + %.2f', slope, intercept);

% Find the goodness of fit
y_predicted = polyval(coefficients, tone_sig_corr_opp);
residuals = tone_noise_corr_opp - y_predicted;
mean_squared_error = mean(residuals.^2);
r_squared = 1 - (mean_squared_error / var(tone_noise_corr_opp));

% Display the line equation and goodness of fit
disp(line_equation);
disp(['R-squared: ', num2str(r_squared)]);
[h,p] = corr(tone_sig_corr_opp, tone_noise_corr_opp)
figure;
scatter(tone_sig_corr_opp, tone_noise_corr_opp);
hold on;
plot(tone_sig_corr_opp, y_predicted, 'r', 'LineWidth', 2);
hold off;
xlabel('tone sig corr');
ylabel('tone noise corr');
title(sprintf('Scatter Plot with Line Fit\n%s\nR-squared: %.4f', line_equation, r_squared));

% -+++ ++  All

coefficients = polyfit(tone_sig_corr, tone_noise_corr, 1);

% Get the line equation
slope = coefficients(1);
intercept = coefficients(2);
line_equation = sprintf('y = %.2fx + %.2f', slope, intercept);

% Find the goodness of fit
y_predicted = polyval(coefficients, tone_sig_corr);
residuals = tone_noise_corr - y_predicted;
mean_squared_error = mean(residuals.^2);
r_squared = 1 - (mean_squared_error / var(tone_noise_corr));

% Display the line equation and goodness of fit
disp(line_equation);
disp(['R-squared: ', num2str(r_squared)]);
[h,p] = corr(tone_sig_corr, tone_noise_corr)

% Draw scatter plot with line fit
figure;
scatter(tone_sig_corr, tone_noise_corr);
hold on;
plot(tone_sig_corr, y_predicted, 'r', 'LineWidth', 2);
hold off;
xlabel('tone sig corr');
ylabel('tone noise corr');
title(sprintf('Scatter Plot with Line Fit\n%s\nR-squared: %.4f', line_equation, r_squared));

