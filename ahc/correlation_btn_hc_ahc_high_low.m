clear;close all;clc;
load('stage1_db.mat')
all_sg_triples = [];
for u=1:size(stage1_db,1)
    if stage1_db{u,4} == 2
        rates = stage1_db{u,7};
        % spont
        spont = [];
        for f=1:6
            spont = [spont; mean(rates{f,1}(:,431:500),2)];
        end % f

        % tests
        sig6 = zeros(6,1);
        for f=1:6
            sig6(f) = ttest2(spont, mean(rates{f,1}(:, 501:570),2));
        end % f

        rates6 = zeros(6,1);
        for f=1:6
            rates6(f) = mean(mean(rates{f,1}(:,501:570),2));
        end
        
        
        if sum(sig6([1,3,5])) ~= 0
            % 1 3 5
            all_sg_triples = [ all_sg_triples; [rates6(1) rates6(3) rates6(5)] ];
        end

        if sum(sig6([2,4,6])) ~= 0
            % 1 3 5
            all_sg_triples = [ all_sg_triples; [rates6(2) rates6(4) rates6(6)] ];
        end

    end % if 
end % u

%%
figure
% Create two example vectors
x = all_sg_triples(:,1);
y = all_sg_triples(:,2);

% Plot the scatter plot
scatter(x, y);
xlabel('HC');
ylabel('AHC Low');
title('HC, AHC Low')
% Add a line of best fit
coefficients = polyfit(x, y, 1);
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(coefficients, x_fit);
hold on;
plot(x_fit, y_fit, 'r');
hold off;

% Calculate the Pearson correlation coefficient
[r, p] = corrcoef(x, y);
fprintf('Pearson correlation coefficient: %f\n', r(1,2));
fprintf('p-value: %f\n', p(1,2));

%%
figure
% Create two example vectors
x = all_sg_triples(:,2);
y = all_sg_triples(:,3);

% Plot the scatter plot
scatter(x, y);
xlabel('AHC Low');
ylabel('AHC High');
title('AHC Low, AHC High')
% Add a line of best fit
coefficients = polyfit(x, y, 1);
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(coefficients, x_fit);
hold on;
plot(x_fit, y_fit, 'r');
hold off;

% Calculate the Pearson correlation coefficient
[r, p] = corrcoef(x, y);
fprintf('Pearson correlation coefficient: %f\n', r(1,2));
fprintf('p-value: %f\n', p(1,2));

%%
figure
% Create two example vectors
x = all_sg_triples(:,1);
y = all_sg_triples(:,3);

% Plot the scatter plot
scatter(x, y);
xlabel('HC');
ylabel('AHC High');
title('HC, AHC High')
% Add a line of best fit
coefficients = polyfit(x, y, 1);
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(coefficients, x_fit);
hold on;
plot(x_fit, y_fit, 'r');
hold off;

% Calculate the Pearson correlation coefficient
[r, p] = corrcoef(x, y);
fprintf('Pearson correlation coefficient: %f\n', r(1,2));
fprintf('p-value: %f\n', p(1,2));
