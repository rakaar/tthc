function moving_avg_rate = moving_avg(rate, bin_size, step_size)
    bin_start_pts = 1:step_size:length(rate)- bin_size + 1;
    moving_avg_rate = zeros(length(bin_start_pts),1);
    
    for b=1:length(bin_start_pts)
        moving_avg_rate(b) = mean(rate(bin_start_pts(b):bin_start_pts(b)+bin_size-1));
    end
end

% u = 75;
% f = 3;
% bin_size = 25;
% 
% r = mean( rms_match_db{u,6}{f,1}(:, 301:1000) );
% plot(  moving_avg(r, bin_size, 10)  )