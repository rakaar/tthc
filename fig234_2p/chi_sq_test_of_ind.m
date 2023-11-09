function [chi_sq_val, p_val] = chi_sq_test_of_ind(data_table)

    % calculate degrees of freedom
    dof = (size(data_table,1) - 1) * (size(data_table,2) - 1);

    % calculate expected values
    expected_tab = zeros(size(data_table));
    for i=1:size(data_table,1)
        for j=1:size(data_table,2)
            % row total * column total / total
            expected_tab(i,j) = (sum(data_table(i,:))*sum(data_table(:,j)))/sum(data_table(:));
        end
    end

    % (observed - expected)^2 / expected
    diff_sq = (data_table - expected_tab).^2;
    diff_sq_by_obv = diff_sq./expected_tab;

    chi_sq_val = sum(diff_sq_by_obv(:));
    p_val = 1 - chi2cdf(chi_sq_val, dof);

end