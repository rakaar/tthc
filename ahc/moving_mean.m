function mean_vec = moving_mean(vec, bin_size, window_size)
    window_starting_pts = 1:window_size:length(vec)-bin_size;
    mean_vec = zeros(1,length(window_starting_pts),1);
    for w=1:length(window_starting_pts)
        t_start = window_starting_pts(w);
        t_end = t_start + bin_size;
        mean_vec(w) = mean(vec(t_start:t_end));
    end % for
end