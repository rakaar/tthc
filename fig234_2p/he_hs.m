rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
near_far_units = cell(2,4);
near_far_counter = zeros(2,4);
for u=1:size(rms_match_db_with_sig_bf)
    tone_bf = rms_match_db_with_sig_bf{u,11};
    if  tone_bf == -1
        continue
    end

    for hf=1:5
        t1_i = hf;
        t2_i = hf + 2;
        t1t2_i = hf;


        d1 = abs(t1_i - tone_bf)*0.5;

        d2 = abs(t2_i - tone_bf)*0.5;

        if d1 <= 1 && d2 <= 1
            near_or_far = 1;
        else
            near_or_far = 2;
        end

        t1_rates = mean(rms_match_db_with_sig_bf{u,8}{t1_i,1}(:, 10:14),2);
        t2_rates = mean(rms_match_db_with_sig_bf{u,8}{t2_i,1}(:, 10:14),2);
        t1t2_rates = mean(rms_match_db_with_sig_bf{u,9}{t1t2_i,1}(:, 10:14),2);

        t1_mean_rate = mean(t1_rates);
        t2_mean_rate = mean(t2_rates);
        t1t2_mean_rate = mean(t1t2_rates);

        t1_sig = rms_match_db_with_sig_bf{u,10}(t1_i);
        t2_sig = rms_match_db_with_sig_bf{u,10}(t2_i);
        t1t2_sig = rms_match_db_with_sig_bf{u,12}(t1t2_i);

        if t1_sig + t2_sig + t1t2_sig == 0
          type = 4;
        end

        if t1t2_sig == 1 && (t1_sig + t2_sig == 0)
            type = 1;
        end

        if t1t2_sig == 0 && (t1_sig + t2_sig >= 1)
            type = 2;
        end

        if t1t2_sig == 1 && (t1_sig + t2_sig >= 1)
            if t1_sig == 1 && t2_sig == 0
                hsig = ttest2(t1_rates, t1t2_rates);
                if hsig == 1
                    if t1t2_mean_rate > t1_mean_rate
                        type = 1;
                    else
                        type = 2;
                    end
                else
                    type = 3;
                end % t1 superior
            end

            if t2_sig == 1 && t1_sig == 0
                hsig = ttest2(t2_rates, t1t2_rates);
                if hsig == 1
                    if t1t2_mean_rate > t2_mean_rate
                        type = 1;
                    else
                        type = 2;
                    end
                else
                    type = 3;
                end % t2 superior 
            end 
        end

        if t1_sig == 1 && t2_sig == 1
            %%%
            if t1_mean_rate ~= t2_mean_rate
                if t1t2_mean_rate > max(t1_mean_rate, t2_mean_rate)
                    if t1_mean_rate > t2_mean_rate
                        t_rates = t1_rates;
                    else
                        t_rates = t2_rates;
                    end

                    if ttest2(t1t2_rates, t_rates) == 1
                        type = 1;
                    else
                        type = 3;
                    end
                      

                elseif t1t2_mean_rate < min(t1_mean_rate, t2_mean_rate)
                            if t1_mean_rate < t2_mean_rate
                                t_rates = t1_rates;
                            else
                                t_rates = t2_rates;
                            end
        
                            if ttest2(t1t2_rates, t_rates) == 1
                                type = 2;
                            else
                                type = 3;
                            end
                else
                    type = 3;
                end
            elseif t1_mean_rate == t2_mean_rate
                if t1t2_mean_rate > t1_mean_rate
                    if ttest2(t1t2_rates, t1_rates) == 1
                        a = 1;
                    else
                        a = 0;
                    end

                    if ttest2(t1t2_rates, t2_rates) == 1
                        b = 1;
                    else
                        b = 0;
                    end

                    if a + b > 0
                        type = 1;
                    else
                        type = 3;
                    end
                elseif t1t2_mean_rate < t1_mean_rate
                    if ttest2(t1t2_rates, t1_rates) == 1
                        a = -1;
                    else
                        a = 0;
                    end

                    if ttest2(t1t2_rates, t2_rates) == 1
                        b = -1;
                    else
                        b = 0;
                    end

                    if a + b < 0
                        type = 2;
                    else
                        type = 3;
                    end
                elseif t1t2_mean_rate == t1_mean_rate
                    type = 3;
                end
            end
            %%%

            
        end


         near_far_units{near_or_far,type} = [near_far_units{near_or_far,type} u];
         near_far_counter(near_or_far,type) = near_far_counter(near_or_far,type) + 1;

    end % hf 1 to 5
end

%% 
close all
figure
    bar(near_far_counter(1,:)./sum(near_far_counter(1,:)))
    title('near')
figure
    bar(near_far_counter(2,:)./sum(near_far_counter(2,:)))
    title('far')