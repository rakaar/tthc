function noise_vec = noise_vec_gen(response_cell)
    % response_cell is 7 x 1 cell
    noise_vec = [];
    for s = 1:size(response_cell,1)
       rate_5_iters = mean(response_cell{s,1}(:, 10:14),2);
       mean_rate = mean(rate_5_iters);
       noise_vec = [noise_vec; rate_5_iters - mean_rate];

    end
end