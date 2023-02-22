bin_size = 25;
step_size = 10;

m1 = tone_scale_tone_response;
m2 = tone_scale_hc_response;


% normalised rate
norm_windows_start = 1:step_size:700-bin_size;
m1_norm = cell(11, 1);
for re=1:11
    current_rate = m1{1,re}(:, 301:1000);
    norm_rate = zeros(size(current_rate,1), length(norm_windows_start));
    % bin
    for u=1:size(current_rate,1)
        for n=1:length(norm_windows_start)
            t_start = norm_windows_start(n);
            t_end = t_start + bin_size - 1;

            norm_rate(u,n) = mean(current_rate(u,t_start:t_end));
        end % end of n
    end % end of u
    % divide by max to norm
    for u=1:size(norm_rate,1)
        norm_rate(u,:) = norm_rate(u,:)./max( norm_rate(u,:) );
    end % t
    
    m1_norm{re,1} = norm_rate;
    
end %re


m2_norm = cell(11, 1);
for re=1:11
    current_rate = m2{1,re}(:, 301:1000);
    norm_rate = zeros(size(current_rate,1), length(norm_windows_start));
    % bin
    for u=1:size(current_rate,1)
        for n=length(norm_windows_start)
            t_start = norm_windows_start(n) ;
            t_end = t_start + bin_size - 1;

            norm_rate(u,n) = mean(current_rate(u,t_start:t_end));
        end % end of n
    end % end of u
    % divide by max to norm
    for u=1:size(norm_rate,1)
        norm_rate(u,:) = norm_rate(u,:)./max( norm_rate(u,:) );
    end % t
    
    m2_norm{re,1} = norm_rate;
    
end %re


% h matrix
h_matrix = zeros(11, length(26:68));
for re=1:11
    r1 = m1_norm{re,1};
    r2 = m2_norm{re,1};
    
    
    for t=26:68
        h_matrix(re, t-25) = ttest2(r1(:, t), r2(:, t));
    end
end