%% su
clear all;
load('E:\RK TTHC Data\SingleUnit\rms_match_db.mat')
units_bf = [];
units_bf0 = [];
freqs = log2([6,8.5,12,17,24,34,48]);
for u=1:size(rms_match_db,1)
    tbf = rms_match_db{u,12};
    hbf = rms_match_db{u,13};
    if tbf ~= -1 && hbf ~= -1
        units_bf = [units_bf freqs(tbf)];
        units_bf0 = [units_bf0 freqs(hbf)];
    end
end % u
[bfbf0_corr_mat, p_mat] = corrcoef(units_bf, units_bf0);

% fit a line
x = units_bf;
y = units_bf0;
coefficients = polyfit(x, y, 1);

% Extract the slope and intercept from the coefficients
slope = coefficients(1);
intercept = coefficients(2);

% error
% Fit a line to the data using polyfit
coefficients = polyfit(x, y, 1);

% Evaluate the line at the data points
y_fit = polyval(coefficients, x);

% Calculate the root-mean-squared error (RMSE)
rmse = sqrt(mean((y - y_fit).^2));

% Calculate the R-squared (R2) value
y_mean = mean(y);
ss_tot = sum((y - y_mean).^2);
ss_res = sum((y - y_fit).^2);
r2 = 1 - (ss_res/ss_tot);

% Display the RMSE and R2 values
fprintf('RMSE: %.4f\n', rmse);
fprintf('R2: %.4f\n', r2);

figure
plot(x, y, 'o');
hold on;
plot(x, slope*x + intercept);
hold off
title(['SU corr coef = ', num2str(bfbf0_corr_mat(1,2)), ' p = ', num2str(p_mat(1,2)), ' R2 = ', num2str(r2)]);
legend('Data Points', 'Fitted Line');
