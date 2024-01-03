
% function for individual he hs classifier
function case_type = indiv_he_hs_classifier(t1_spike_rates, t2_spike_rates, t1t2_spike_rates, t1_sig, t2_sig, t1t2_sig)
    % t1_rates - 5 x 1 -  rates of base Tone
    % t2_rates - 5 x 1 - rates of second component Tone
    % t1t2_rates - 5 x 1 - rates of t1+t2 TTHC

    % t1_sig - 0/1 - significant res or not for base Tone
    % t2_sig - 0/1 - significant res or not for second component Tone
    % t1t2_sig - 0/1 - significant res or not for t1+t2 TTHC

    case_type = nan;

    
    t1_mean_rate = mean(t1_spike_rates);
    t2_mean_rate = mean(t2_spike_rates);
    t1t2_mean_rate = mean(t1t2_spike_rates);


    if t1_sig + t2_sig + t1t2_sig == 0 % NS
        case_type = 4;
    elseif (t1t2_sig == 1) && (t1_sig + t2_sig == 0) % HE
        case_type = 1;
    elseif t1t2_sig == 0 && (t1_sig + t2_sig > 0) % HS
        case_type = 2;
    elseif t1t2_sig == 1 && (t1_sig + t2_sig > 0) % HE or HS
        if t1_sig == 1 && t2_sig == 0
            t_spike_rates = t1_spike_rates;
            t_mean_rate = t1_mean_rate;

            if t1t2_mean_rate > t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                case_type = 1;
            elseif t1t2_mean_rate < t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                case_type = 2;
            else
                case_type = 3;
            end
        elseif t1_sig == 0 && t2_sig == 1
            t_spike_rates = t2_spike_rates;
            t_mean_rate = t2_mean_rate;

            if t1t2_mean_rate > t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                case_type = 1;
            elseif t1t2_mean_rate < t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                case_type = 2;
            else
                case_type = 3;
            end
        elseif t1_sig == 1 && t2_sig == 1
           if t1_mean_rate > t2_mean_rate
             t_spike_rates = t1_spike_rates;
             t_mean_rate = t1_mean_rate;
                if t1t2_mean_rate > t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                    case_type = 1;
                elseif t1t2_mean_rate < t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                    case_type = 2;
                else
                    case_type = 3;
                end
           elseif t2_mean_rate > t1_mean_rate
             t_spike_rates = t2_spike_rates;
             t_mean_rate = t2_mean_rate;
                if t1t2_mean_rate > t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                    case_type = 1;
                elseif t1t2_mean_rate < t_mean_rate && ttest2(t_spike_rates, t1t2_spike_rates) == 1
                    case_type = 2;
                else
                    case_type = 3;
                end
           else
                if t1t2_mean_rate > t1_mean_rate && (ttest2(t1_spike_rates, t1t2_spike_rates) == 1 || ttest2(t2_spike_rates, t1t2_spike_rates) == 1)
                    case_type = 1;
                elseif t1t2_mean_rate < t1_mean_rate && (ttest2(t1_spike_rates, t1t2_spike_rates) == 1 || ttest2(t2_spike_rates, t1t2_spike_rates) == 1)
                    case_type = 2;
                else
                    case_type = 3;
                end        
            end

        end
    end

end