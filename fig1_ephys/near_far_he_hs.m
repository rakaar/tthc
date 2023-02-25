clear ;close all;
load('rms_match_db.mat')

near_counter = 0;
far_counter = 0;

near_far_stats = zeros(2,4);
near_far_units = cell(2,4);
% he, hs, ne, ns

for u=1:size(rms_match_db,1)
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
            near_far_stats(nf,4) = near_far_stats(nf,4) + 1; 
            near_far_units{nf,4} = [near_far_units{nf,4}; u];
        elseif (t1_sig + t2_sig == 0) && t1t2_sig == 1
            near_far_stats(nf,1) = near_far_stats(nf,1) + 1;
            near_far_units{nf,1} = [near_far_units{nf,1}; u];
        elseif (t1_sig + t2_sig >= 1) && (t1t2_sig == 0)
            near_far_stats(nf,2) = near_far_stats(nf,2) + 1;
            near_far_units{nf,2} = [near_far_units{nf,2}; u];
        elseif (t1_sig + t2_sig >= 1) && (t1t2_sig == 1)
            if t1_sig == 1 && t2_sig == 0
                [sigval, ~] = ttest2(t1_all_iters, t1t2_all_iters);
                if sigval == 1
                    if t1t2_mean_rate > t1_mean_rate
        	            near_far_stats(nf,1) = near_far_stats(nf,1) + 1;
                        near_far_units{nf,1} = [near_far_units{nf,1}; u];
                    elseif t1t2_mean_rate < t1_mean_rate
                        near_far_stats(nf,2) = near_far_stats(nf,2) + 1;
                        near_far_units{nf,2} = [near_far_units{nf,2}; u];
                    end
                else
                        near_far_stats(nf,3) = near_far_stats(nf,3) + 1;
                        near_far_units{nf,3} = [near_far_units{nf,3}; u];
                end
           
            elseif t1_sig == 0 && t2_sig == 1
                [sigval, ~] = ttest2(t2_all_iters, t1t2_all_iters);
                if sigval == 1
                    if t1t2_mean_rate > t2_mean_rate
        	            near_far_stats(nf,1) = near_far_stats(nf,1) + 1;
                        near_far_units{nf,1} = [near_far_units{nf,1}; u];
                    elseif t1t2_mean_rate < t2_mean_rate
                        near_far_stats(nf,2) = near_far_stats(nf,2) + 1;
                        near_far_units{nf,2} = [near_far_units{nf,2}; u];
                    end
                else
                        near_far_stats(nf,3) = near_far_stats(nf,3) + 1;
                        near_far_units{nf,3} = [near_far_units{nf,3}; u];
                end
            elseif t1_sig == 1 && t2_sig == 1
                    if t1_mean_rate > t2_mean_rate
                            [sigval, ~] = ttest2(t1_all_iters, t1t2_all_iters);
                            if sigval == 1
                                if t1t2_mean_rate > t1_mean_rate
	                                near_far_stats(nf,1) = near_far_stats(nf,1) + 1;
                                    near_far_units{nf,1} = [near_far_units{nf,1}; u];
                                elseif t1t2_mean_rate < t1_mean_rate
                                    near_far_stats(nf,2) = near_far_stats(nf,2) + 1;
                                    near_far_units{nf,2} = [near_far_units{nf,2}; u];
                                end
                            else
                                    near_far_stats(nf,3) = near_far_stats(nf,3) + 1;
                                    near_far_units{nf,3} = [near_far_units{nf,3}; u];
                            end
                    elseif t2_mean_rate > t1_mean_rate
                            [sigval, ~] = ttest2(t2_all_iters, t1t2_all_iters);
                            if sigval == 1
                                if t1t2_mean_rate > t2_mean_rate
                                    near_far_stats(nf,1) = near_far_stats(nf,1) + 1;
                                    near_far_units{nf,1} = [near_far_units{nf,1}; u];
                                elseif t1t2_mean_rate < t2_mean_rate
                                    near_far_stats(nf,2) = near_far_stats(nf,2) + 1;
                                    near_far_units{nf,2} = [near_far_units{nf,2}; u];
                                end
                            else
                                    near_far_stats(nf,3) = near_far_stats(nf,3) + 1;
                                    near_far_units{nf,3} = [near_far_units{nf,3}; u];
                            end
                    elseif t1_mean_rate == t2_mean_rate
                        hehsne_1 = 0;
                        hehsne_2 = 0;

                        [sig,~] = ttest2(t1_all_iters, t1t2_all_iters);
                        if sig == 1
                            if t1t2_mean_rate > t1_mean_rate
                                hehsne_1 = 1;
                            elseif t1t2_mean_rate < t1_mean_rate
                                hehsne_1 = -1;
                            end
                        elseif sig == 0
                            hehsne_1 = 0;
                        end


                        [sig,~] = ttest2(t2_all_iters, t1t2_all_iters);
                        if sig == 1
                            if t1t2_mean_rate > t2_mean_rate
                                hehsne_2 = 1;
                            elseif t1t2_mean_rate < t2_mean_rate
                                hehsne_2 = -1;
                            end
                        elseif sig == 0
                            hehsne_2 = 0;
                        end


                        final_score = hehsne_1 + hehsne_2;
                        if final_score == 0
                            near_far_stats(nf,3) = near_far_stats(nf,3) + 1;
                            near_far_units{nf,3} = [near_far_units{nf,3};u];
                        elseif final_score > 0
                            near_far_stats(nf,1) = near_far_stats(nf,1) + 1;
                            near_far_units{nf,1} = [near_far_units{nf,1};u];
                        elseif final_score < 0
                            near_far_stats(nf,2) = near_far_stats(nf,2) + 1;
                            near_far_units{nf,2} = [near_far_units{nf,2};u];
                        end
                        
                    end
            end
        end
   end

end
%%
close all
figure
    bar(near_far_stats(1,:))
    title('near')
figure
    bar(near_far_stats(2,:))
    title('far')