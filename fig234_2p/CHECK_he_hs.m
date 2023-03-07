% near he
u_check = [];
rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    if tbf == -1
        continue
    end

    for hf=1:5
        t1i = hf;
        t2i = hf + 2;
        t1t2i = hf;


        d1 = abs(tbf - t1i)*0.5;
        d2 = abs(tbf - t2i)*0.5;

        if (d1 <= 1 && d2 <= 1)
            t1sig = rms_match_db_with_sig_bf{u,10}(t1i);
            t2sig = rms_match_db_with_sig_bf{u,10}(t2i);
            t1t2sig = rms_match_db_with_sig_bf{u,12}(t1t2i);

            t1_5 = mean(rms_match_db_with_sig_bf{u,8}{t1i,1}(:,10:14),2);
            t2_5 = mean(rms_match_db_with_sig_bf{u,8}{t2i,1}(:,10:14),2);
            t1t2_5 = mean(rms_match_db_with_sig_bf{u,9}{t1t2i,1}(:,10:14),2);

            if t1t2sig == 1 && (t1sig + t2sig == 0)
                u_check = [u_check u];
            end

            if t1t2sig == 1 && (t1sig + t2sig >= 1)
                if t1sig == 1 && t2sig == 0
                    hsig = ttest2(t1_5, t1t2_5);
                    if hsig == 1
                        if mean(t1t2_5) > mean(t1_5)
                            u_check = [u_check u];
                        end
                    end
                end

                if t2sig == 1 && t1sig == 0
                        hsig = ttest2(t2_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) > mean(t2_5)
                                u_check = [u_check u];
                            end
                        end
                end

                if t1sig == 1 && t2sig == 1
                    if mean(t1_5) > mean(t2_5)
                        hsig = ttest2(t1_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) > mean(t1_5)
                                u_check = [u_check u];
                            end
                        end

                    elseif mean(t2_5) > mean(t1_5)
                             hsig = ttest2(t2_5, t1t2_5);
                             if hsig == 1
                                if mean(t1t2_5) > mean(t2_5)
                                    u_check = [u_check u];
                                end
                             end
                    elseif mean(t1_5) == mean(t2_5)
                        a = 0;
                        b = 0;
                        hsig = ttest2(t1_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) > mean(t1_5)
                                a = 1;
                            else 
                                a = -1;
                            end
                        end

                        hsig = ttest2(t2_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) > mean(t2_5)
                                b = 1;
                            else    
                                b = -1;
                            end
                        end

                        if a + b > 0
                            u_check = [u_check u];
                        end

                    end
                end
            end
        end
    end
end

%% for supp

% near he
u_check = [];
rms_match_db_with_sig_bf = load('rms_match_db_with_sig_bf.mat').rms_match_db_with_sig_bf;
for u=1:size(rms_match_db_with_sig_bf,1)
    tbf = rms_match_db_with_sig_bf{u,11};
    if tbf == -1
        continue
    end

    for hf=1:5
        t1i = hf;
        t2i = hf + 2;
        t1t2i = hf;


        d1 = abs(tbf - t1i)*0.5;
        d2 = abs(tbf - t2i)*0.5;

        if (d1 <= 1 && d2 <= 1)
            t1sig = rms_match_db_with_sig_bf{u,10}(t1i);
            t2sig = rms_match_db_with_sig_bf{u,10}(t2i);
            t1t2sig = rms_match_db_with_sig_bf{u,12}(t1t2i);

            t1_5 = mean(rms_match_db_with_sig_bf{u,8}{t1i,1}(:,10:14),2);
            t2_5 = mean(rms_match_db_with_sig_bf{u,8}{t2i,1}(:,10:14),2);
            t1t2_5 = mean(rms_match_db_with_sig_bf{u,9}{t1t2i,1}(:,10:14),2);

            if t1t2sig == 0 && (t1sig + t2sig >= 1)
                u_check = [u_check u];
            end

            if t1t2sig == 1 && (t1sig + t2sig >= 1)
                if t1sig == 1 && t2sig == 0
                    hsig = ttest2(t1_5, t1t2_5);
                    if hsig == 1
                        if mean(t1t2_5) < mean(t1_5)
                            u_check = [u_check u];
                        end
                    end
                end

                if t2sig == 1 && t1sig == 0
                        hsig = ttest2(t2_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) < mean(t2_5)
                                u_check = [u_check u];
                            end
                        end
                end

                if t1sig == 1 && t2sig == 1
                    if mean(t1_5) > mean(t2_5)
                        hsig = ttest2(t1_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) < mean(t1_5)
                                u_check = [u_check u];
                            end
                        end

                    elseif mean(t2_5) > mean(t1_5)
                             hsig = ttest2(t2_5, t1t2_5);
                             if hsig == 1
                                if mean(t1t2_5) > mean(t2_5)
                                    u_check = [u_check u];
                                end
                             end
                    elseif mean(t1_5) == mean(t2_5)
                        a = 0;
                        b = 0;
                        hsig = ttest2(t1_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) > mean(t1_5)
                                a = 1;
                            else 
                                a = -1;
                            end
                        end

                        hsig = ttest2(t2_5, t1t2_5);
                        if hsig == 1
                            if mean(t1t2_5) > mean(t2_5)
                                b = 1;
                            else    
                                b = -1;
                            end
                        end

                        if a + b > 0
                            u_check = [u_check u];
                        end

                    end
                end
            end
        end
    end
end