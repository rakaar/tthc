% Get the handle of the current figure
fig = gcf;

% Get handles to all axes in the figure
axesHandles = findall(fig, 'type', 'axes');
h1=get(gca,'title');
figFilename = get(fig, 'FileName');

% Initialize cell arrays to store X and Y data for each line
allXData = zeros(5, 15);  % Assuming 5 curves
allYData = zeros(5, 15);

% Loop through each axis
for i = 1:length(axesHandles)
    % Get the data from each line in the current axis
    lineHandles = findall(axesHandles(i), 'type', 'line');
    for j = 1:length(lineHandles)
        xData = get(lineHandles(j), 'XData');
        yData = get(lineHandles(j), 'YData');
        
        % Store the X and Y data in cell arrays
        allXData(j,:) = xData;
        allYData(j,:) = yData;
    end
end

% Display or use the extracted data as needed
% for k = 1:length(allXData)
%     fprintf('Curve %d:\n', k);
%     fprintf('X Data: %s\n', mat2str(allXData{k}));
%     fprintf('Y Data: %s\n', mat2str(allYData{k}));
% end

%  allYData - calculte mean and std error across 1st dimension
mean_allYData = mean(allYData,1);
std_allYData = std(allYData,1);
std_error = std_allYData./sqrt(size(allYData,1));
% plot error bar
figure
errorbar(mean_allYData,std_error)
title(h1.String)
ylim([-0.3 0.4])
saveas(gcf, strrep(figFilename, '/final/', '/without_indiv_trials/'))