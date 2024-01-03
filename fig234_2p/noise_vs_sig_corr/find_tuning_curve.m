function tuning_curve = find_tuning_curve(response_cell)
    % response_cell is 7 x 1

    tuning_curve = zeros(7, 1);
    for s = 1:7
        tuning_curve(s) = mean(mean(response_cell{s,1}(:, 10:14),2));
    end
end