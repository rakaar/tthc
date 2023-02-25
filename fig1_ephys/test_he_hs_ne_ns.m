random_unit = randi([1 643]);

% near he

testu = [];
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
            if (t1_sig == 0) && (t2_sig == 0) && (t1t2_sig == 1)
                testu = [testu; u];
            end

            if (t1_sig + t2_sig >= 1) && (t1t2_sig == 1)
                if t1_sig == 1 && t2_sig == 0
                    if (t1t2_mean_rate > t1_mean_rate) && (ttest2(t1t2_all_iters, t1_all_iters))
                        testu = [testu; u];
                    end
                elseif t1_sig == 0 && t2_sig == 1
                    if (t1t2_mean_rate > t2_mean_rate) && (ttest2(t1t2_all_iters, t2_all_iters))
                        testu = [testu; u];
                    end
                elseif t1_sig == 1 && t2_sig == 1
                     if t1_mean_rate > t2_mean_rate
                        if (t1t2_mean_rate > t1_mean_rate) && (ttest2(t1t2_all_iters, t1_all_iters))
                            testu = [testu; u];
                        end
                     elseif t2_mean_rate > t1_mean_rate
                            if (t1t2_mean_rate > t2_mean_rate) && (ttest2(t1t2_all_iters, t2_all_iters))
                                testu = [testu; u];
                            end
                     elseif t1_mean_rate == t2_mean_rate
                        if t1t2_mean_rate > t1_mean_rate 
                            a = 0; b = 0;
                            if ttest2(t1t2_all_iters, t1_all_iters)
                                a = 1;
                            end

                            if ttest2(t1t2_all_iters, t2_all_iters)
                                b = 1;
                            end

                            if a + b > 0
                                testu = [testu; u];
                            end
                        end
                     end
                end
            end

        end

    end


end

sum(abs(testu - near_far_units{1,1}))
% far hs

testu = [];
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
        if ~(d1 <= 1 && d2 <= 1)
            if (t1_sig + t2_sig >= 1) && (t1t2_sig == 0)
                testu = [testu; u];
            end

            if (t1_sig + t2_sig >= 1) && (t1t2_sig == 1)
                if t1_sig == 1 && t2_sig == 0
                    if (t1t2_mean_rate < t1_mean_rate) && (ttest2(t1t2_all_iters, t1_all_iters))
                        testu = [testu; u];
                    end
                elseif t1_sig == 0 && t2_sig == 1
                    if (t1t2_mean_rate < t2_mean_rate) && (ttest2(t1t2_all_iters, t2_all_iters))
                        testu = [testu; u];
                    end
                elseif t1_sig == 1 && t2_sig == 1
                     if t1_mean_rate > t2_mean_rate
                        if (t1t2_mean_rate < t1_mean_rate) && (ttest2(t1t2_all_iters, t1_all_iters))
                            testu = [testu; u];
                        end
                     elseif t2_mean_rate > t1_mean_rate
                            if (t1t2_mean_rate < t2_mean_rate) && (ttest2(t1t2_all_iters, t2_all_iters))
                                testu = [testu; u];
                            end
                     elseif t1_mean_rate == t2_mean_rate
                        if t1t2_mean_rate < t1_mean_rate 
                            a = 0; b = 0;
                            if ttest2(t1t2_all_iters, t1_all_iters)
                                a = 1;
                            end

                            if ttest2(t1t2_all_iters, t2_all_iters)
                                b = 1;
                            end

                            if a + b > 0
                                testu = [testu; u];
                            end
                        end
                     end
                end
            end

        end

    end


end


sum(abs(testu - near_far_units{2,2}))
