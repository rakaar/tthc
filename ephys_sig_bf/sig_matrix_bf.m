% stim = 'tone';
stim = 'hc';

% bonferoni correction
bonferoni_factor = 1; % 7 or 1
% bonferoni_factor = 1; % 7 or 1
if strcmp(stim, 'tone')
    db_lvls = 0:10:40;
    units_db = load('ephys_tone_33.mat').ephys_tone_33;
    n_units = 359;
elseif strcmp(stim, 'hc')
    db_lvls = 0:5:45;
    units_db = load('ephys_hc_33.mat').ephys_hc_33;
    n_units = 333;
end

for u=1:n_units
    u_rates = units_db{u,4};
    sig_matrix = nan(7, length(db_lvls));
    rate_matrix = nan(7,length(db_lvls));
    h = nan;
    bf = -1;
  
    
    for d=1:length(db_lvls)
        each_db_rates = u_rates{d,2};
        if isempty(each_db_rates)
            continue
        end
        

        % get spont and stim res
        spont = [];
        rates = cell(7,1);
        mean_rates = zeros(7,1);
        h_per_db = zeros(7,1);
        
        for f=1:7
            each_db_each_f_rates = each_db_rates{f,1};
            % spont
            spont_durn_rate = each_db_each_f_rates(:,431:500);
            spont_mean_across_time = mean(spont_durn_rate, 2);
            spont = [spont; spont_mean_across_time];
        end

        mean_spont = mean(spont);
        std_spont = std(spont);

        % do tests and get fill matrix
        for f=1:7
            rates_f = mean(each_db_rates{f,1}(:,501:570),2);
            mean_rates_f = mean(rates_f);
            std_rates_f = std(rates_f);

            % Commenting d_prime and using ttest
%             d_prime = (mean_rates_f - mean_spont)/((std_rates_f^2  +  std_spont^2)^0.5);
            if ttest2(rates_f, spont, 'alpha', 0.05/bonferoni_factor) == 1
                sig_matrix(f,d) = 1;
            else
                sig_matrix(f,d) = 0;
            end

            rate_matrix(f,d) = mean_rates_f;
        end

    end % end of d

    % h
    if sum(nansum(sig_matrix)) > 0
        h = 1;
    else
        h = 0;
    end

    % bf
    for d=length(db_lvls):-1:1
        if h == 0
            bf = -1;
            break
        end

        if isnan(rate_matrix(1,d)) || sum(sig_matrix(:,d)) == 0
            continue
        else
           sig_indices = find(sig_matrix(:,d) > 0);
           if isempty(sig_indices) 
               continue
           end
           sig_rates_per_d = rate_matrix(sig_indices,d);
           [max_rate, max_index] = max(sig_rates_per_d);
           bf = sig_indices(max_index);
           break
        end
    end

    units_db{u,5} = sig_matrix;
    units_db{u,6} = h;

    units_db{u,7} = rate_matrix;
    units_db{u,8} = bf;
end % end of u



if strcmp(stim, 'tone')
    ephys_tone_33_5_and_6_sig_7_rates_8_bf = units_db;
    save('ephys_tone_33_5_and_6_sig_7_rates_8_bf', 'ephys_tone_33_5_and_6_sig_7_rates_8_bf')
elseif strcmp(stim, 'hc')
    ephys_hc_33_5_and_6_sig_7_rates_8_bf = units_db;
    save('ephys_hc_33_5_and_6_sig_7_rates_8_bf', 'ephys_hc_33_5_and_6_sig_7_rates_8_bf')
end

