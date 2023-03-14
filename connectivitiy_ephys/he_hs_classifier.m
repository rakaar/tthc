function he_hs_type = he_hs_classifier(tone_rates, hc_rates, tone_sig, hc_sig)
    all_cases = [];
    for hf=1:5
        t1_i = hf;
        t2_i = hf + 2;
        t1t2_i = hf;

        t1_all_iters = mean(tone_rates{t1_i,1}(:,501:570), 2);
        t2_all_iters = mean(tone_rates{t2_i,1}(:,501:570), 2);
        t1t2_all_iters = mean(hc_rates{t1t2_i,1}(:,501:570), 2);

        t1_mean_rate = mean(t1_all_iters);
        t2_mean_rate = mean(t2_all_iters);
        t1t2_mean_rate = mean(t1t2_all_iters);


        t1_sig = tone_sig(t1_i);
        t2_sig = tone_sig(t2_i);
        t1t2_sig = hc_sig(t1t2_i);
        

        if t1_sig + t2_sig + t1t2_sig == 0
            type = 4;
        elseif (t1_sig + t2_sig == 0) && t1t2_sig == 1
            type = 1;
        elseif (t1_sig + t2_sig >= 1) && (t1t2_sig == 0)
            type = 2;
        elseif (t1_sig + t2_sig >= 1) && (t1t2_sig == 1)
            if t1_sig == 1 && t2_sig == 0
                [sigval, ~] = ttest2(t1_all_iters, t1t2_all_iters);
                if sigval == 1
                    if t1t2_mean_rate > t1_mean_rate
        	            type = 1;
                    elseif t1t2_mean_rate < t1_mean_rate
                        type = 2;
                    end
                else
                        type = 3;
                end
           
            elseif t1_sig == 0 && t2_sig == 1
                [sigval, ~] = ttest2(t2_all_iters, t1t2_all_iters);
                if sigval == 1
                    if t1t2_mean_rate > t2_mean_rate
        	            type = 1;
                    elseif t1t2_mean_rate < t2_mean_rate
                        type = 2;
                    end
                else
                        type = 3;
                end
            elseif t1_sig == 1 && t2_sig == 1
                    %%%--
                        if t1_mean_rate	~= t2_mean_rate
                                if t1t2_mean_rate > max(t1_mean_rate, t2_mean_rate) % he/ne
                                    if t1_mean_rate > t2_mean_rate
                                        t_rates = t1_all_iters;
                                    else
                                        t_rates = t2_all_iters;
                                    end
    
                                    if ttest2(t_rates, t1t2_all_iters) == 1
                                        type  = 1;
                                    else
                                        type = 3;
                                    end
                                elseif t1t2_mean_rate < min(t1_mean_rate, t2_mean_rate)  % hs/ne
                                    if t1_mean_rate < t2_mean_rate
                                        t_rates = t1_all_iters;
                                    else
                                        t_rates = t2_all_iters;
                                    end
    
                                    if ttest2(t_rates, t1t2_all_iters) == 1
                                        type  = 2;
                                    else
                                        type = 3;
                                    end


                                else
                                    type = 3;
                                end

                            
    
                        
                        elseif t1_mean_rate == t2_mean_rate
                              if t1t2_mean_rate > t1_mean_rate
                                    if ttest2(t1t2_all_iters,t1_all_iters) == 1
                                        a = 1;
                                    else
                                         a = 0;
                                    end
    
                                    if ttest2(t1t2_all_iters,t2_all_iters) == 1
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
                                    if ttest2(t1t2_all_iters,t1_all_iters) == 1
                                        a = -1;
                                    else
                                         a = 0;
                                    end
    
                                    if ttest2(t1t2_all_iters,t2_all_iters) == 1
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
                    %%%--
                    
            end
        end % DONE
    
        all_cases = [all_cases type];
    end % hf

    if length(find(all_cases == 4)) >= 3
        he_hs_type = 4;
    else 
        he_score = length(find(all_cases == 1));
        hs_score = -length(find(all_cases == 2));
        if he_score + hs_score > 0
            he_hs_type = 1;
        elseif he_score + hs_score < 0
            he_hs_type = 2;
        elseif he_score + hs_score == 0
            he_hs_type = 3;
        end
    end

end