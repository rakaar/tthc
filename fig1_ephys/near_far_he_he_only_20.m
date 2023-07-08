clear ;close all;
load('rms_match_db.mat')

near_counter = 0;
far_counter = 0;

near_far_stats = zeros(2,4);
near_far_units = cell(2,4);
% he, hs, ne, ns

for u=1:size(rms_match_db,1)

    if rms_match_db{u,4} ~= 20
        disp(rms_match_db{u,4})
        continue
    end

   tone_bfi = rms_match_db{u,12};
   if tone_bfi == -1
       continue
   end

   for hf=1:5
        t1_index = hf;
        t2_index = hf + 2;
        t1t2_index = hf;

        t1_sig = rms_match_db{u,8}(t1_index);
        t2_sig = rms_match_db{u,8}(t2_index);
        t1t2_sig = rms_match_db{u,9}(t1t2_index);

        t1_mean_rate = rms_match_db{u,10}(t1_index);
        t2_mean_rate = rms_match_db{u,10}(t2_index);
        t1t2_mean_rate = rms_match_db{u,11}(t1t2_index);

        t1_all_iters = mean(rms_match_db{u,6}{t1_index,1}(:,501:570),2);
        t2_all_iters = mean(rms_match_db{u,6}{t2_index,1}(:,501:570),2);
        t1t2_all_iters = mean(rms_match_db{u,7}{t1t2_index,1}(:,501:570),2);
        
        d1 = abs(tone_bfi - t1_index)*0.5;
        d2 = abs(tone_bfi - t2_index)*0.5;
        if d1 <= 1 && d2 <= 1
            nf = 1;
        else 
            nf = 2;
        end

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


        near_far_stats(nf,type) = near_far_stats(nf,type) + 1;
        near_far_units{nf,type} = [near_far_units{nf,type};u];




   end

end
%%
close all
figure
    bar(near_far_stats(1,:)./sum(near_far_stats(1,:)))
    title('near')
    ylim([0 0.8])
figure
    bar(near_far_stats(2,:)./sum(near_far_stats(2,:)))
    title('far')
    ylim([0 0.8])