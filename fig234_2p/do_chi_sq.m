% do chi square test btn two 1 x n distributions
% dist1, dist2 - 1 x 7

function [h,p] = do_chi_sq(dist1, dist2)

    % Combine your distributions into a contingency table
    contingencyTable = [dist1; dist2] * 1000; % convert to frequencies for chi-square test

    % Perform the chi-square test of independence
    [h,p] = chi2gof(1:numel(dist1), 'Frequency', contingencyTable(1,:), 'Expected', contingencyTable(2,:), 'Alpha', 0.05);

    % h is 1 if the null hypothesis is rejected, and 0 otherwise
    % p is the p-value of the test

end
